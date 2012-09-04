class ChangeCompanyHistoryUserLink < ActiveRecord::Migration
  def change
    remove_column :company_histories, :username
    add_column :company_histories, :user_id, :integer
    add_foreign_key :company_histories, :users
  end
end
