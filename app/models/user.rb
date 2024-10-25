class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :linkedin]

  enum role: [:employee, :hr_manager]

  has_one :employee

  after_initialize :set_default_role, if: :new_record?

  # Method for Google OAuth, updated to work with flat hash structure
  def self.from_google(auth_params)
    where(provider: auth_params[:provider], uid: auth_params[:uid]).first_or_create do |user|
      user.email = auth_params[:email]
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth_params[:full_name]
      user.avatar_url = auth_params[:avatar_url]
      # Add any other fields you want to save
    end
  end

  # Method for LinkedIn OAuth
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |new_user|
      new_user.email = auth.info.email
      new_user.password = Devise.friendly_token[0, 20] # Random password for OAuth users
      new_user.full_name = auth.info.name # Adjusted to match `full_name` field
    end

    # Ensure OTP secret for 2FA is generated for all users (including OAuth)
    user.otp_secret ||= generate_otp_secret
    user.save
    user
  end

  private

  def set_default_role
    self.role ||= :employee
  end
end
