class RenameCompaniesTable < ActiveRecord::Migration
  def change
    rename_column :companies, :company_status_id, :companies_status_id
    rename_column :companies, :company_source_id, :companies_source_id
    rename_table :companies, :companies_companies

    change_table :companies_companies do |t|
      t.foreign_key :companies_statuses, column: 'companies_status_id'
    end
  end
end
