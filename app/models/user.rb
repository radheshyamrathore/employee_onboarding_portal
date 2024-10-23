# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:employee, :hr_manager]
  
  scope :available_for_employee_assignment, -> { where(role: "employee").left_outer_joins(:employee).where(employees: { id: nil }) }

  has_one :employee
  
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :employee
  end
end
