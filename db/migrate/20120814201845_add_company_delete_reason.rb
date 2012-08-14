class AddCompanyDeleteReason < ActiveRecord::Migration
  def change
    add_column :companies, :reason_deleted_on, :string
  end
end
