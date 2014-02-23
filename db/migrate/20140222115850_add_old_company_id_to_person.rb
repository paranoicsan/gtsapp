class AddOldCompanyIdToPerson < ActiveRecord::Migration
  def change
    add_column :people, :old_company_id, :integer
  end
end
