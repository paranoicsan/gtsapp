class ClearBranchWebsite < ActiveRecord::Migration
  def change
    remove_column :branch_websites, :id
    remove_column :branch_websites, :old_branch_id
    rename_table :branch_websites, :branches_websites
  end
end
