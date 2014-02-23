class AddOldIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :old_id, :integer
  end
end
