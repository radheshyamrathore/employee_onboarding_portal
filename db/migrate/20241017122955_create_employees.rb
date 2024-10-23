class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :department
      t.string :role
      t.integer :onboarding_status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
