class AddCompanyAuthors < ActiveRecord::Migration
  def change
    add_column :companies, :author_user_id, :integer
    add_column :companies, :editor_user_id, :integer
    add_foreign_key :companies, :users, :column => 'author_user_id'
    add_foreign_key :companies, :users, :column => 'editor_user_id'
  end
end
