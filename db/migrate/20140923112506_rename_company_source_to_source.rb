class RenameCompanySourceToSource < ActiveRecord::Migration
  def change
    rename_table :company_sources, :companies_sources
  end
end
