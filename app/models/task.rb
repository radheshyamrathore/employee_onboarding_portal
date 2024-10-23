class Task < ApplicationRecord
  belongs_to :employee
  
  enum status: [:pending, :completed]
  
  validates :title, presence: true
end
