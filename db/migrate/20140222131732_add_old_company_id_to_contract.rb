class AddOldCompanyIdToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :old_company_id, :integer
  end
end
