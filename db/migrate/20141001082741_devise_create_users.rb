class DeviseCreateUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :encrypted_password, :string, default: '', null: false
    add_column :users_users, :reset_password_token, :string
    add_column :users_users, :reset_password_sent_at, :datetime
    add_column :users_users, :remember_created_at, :datetime
    add_column :users_users, :current_sign_in_at, :datetime
    add_column :users_users, :last_sign_in_at, :datetime
    add_column :users_users, :last_sign_in_ip, :string
    add_column :users_users, :sign_in_count, :integer
    remove_column :users_users, :crypted_password
    remove_column :users_users, :password_salt
    remove_column :users_users, :persistence_token

    add_index :users_users, :email, unique: true
    add_index :users_users, :reset_password_token, unique: true
  end
end
