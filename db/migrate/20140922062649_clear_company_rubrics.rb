class ClearCompanyRubrics < ActiveRecord::Migration
  def change
    remove_column :company_rubrics, :id
    rename_table :company_rubrics, :companies_rubrics
  end
end
