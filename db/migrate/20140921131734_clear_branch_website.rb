class ClearBranchWebsite < ActiveRecord::Migration
  def change
    rename_table :branch_websites, :branches_websites
  end

  def up
    remove_column :branch_websites, :id
    remove_column :branch_websites, :old_branch_id
  end

  def down
    add_column :branch_websites, :id, :integer
    add_column :branch_websites, :old_branch_id, :integer
  end
end
