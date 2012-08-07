class AddCompanyDescription < ActiveRecord::Migration
  def change
    add_column :companies, :comments, :string
  end
end
