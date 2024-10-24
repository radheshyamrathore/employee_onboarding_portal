class AddAuthFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :avatar_url, :string    
    add_index :users, [:uid, :provider], unique: true
  end
end
