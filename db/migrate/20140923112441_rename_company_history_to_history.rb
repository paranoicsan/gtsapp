class RenameCompanyHistoryToHistory < ActiveRecord::Migration
  def change
    rename_table :company_histories, :companies_histories
  end
end
