class RenameCompanyStatusToStatus < ActiveRecord::Migration
  def change
    rename_table :company_statuses, :companies_statuses
  end
end
