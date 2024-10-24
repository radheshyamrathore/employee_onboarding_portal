class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:linkedin, :google_oauth2]

  enum role: [:employee, :hr_manager]

  has_one :employee

  after_initialize :set_default_role, if: :new_record?

  # Method to handle LinkedIn OAuth login
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  # Method to handle Google OAuth login
  def self.from_google(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end

  private

  def set_default_role
    self.role ||= :employee
  end
end
