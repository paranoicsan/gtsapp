class MoveUsersToModule < ActiveRecord::Migration
  def change
    rename_table :users, :users_users
  end
end
