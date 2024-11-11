class AddAdminUser < ActiveRecord::Migration[7.1]
  def up
    unless AdminUser.exists?(email: 'admin@example.com')
      AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
      puts "Admin user created with email: admin@example.com"
    else
      puts "Admin user already exists"
    end
  end

  def down
    user = AdminUser.find_by(email: 'admin@example.com')
    user&.destroy
  end
end
