class Employee < ApplicationRecord
  belongs_to :user
  has_many :tasks
  
  enum onboarding_status: [:in_progress, :completed]
  
  validates :name, :email, :department, :role, presence: true
  validates :email, uniqueness: true
end
