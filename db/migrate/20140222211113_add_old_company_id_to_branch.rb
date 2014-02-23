class AddOldCompanyIdToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :old_company_id, :integer
  end
end
