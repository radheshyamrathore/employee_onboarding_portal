class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:linkedin] # This is the correct placement

  enum role: [:employee, :hr_manager]

  has_one :employee

  after_initialize :set_default_role, if: :new_record?

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  private

  def set_default_role
    self.role ||= :employee
  end
end
