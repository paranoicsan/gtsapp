class AddOldBranchIdToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :old_branch_id, :integer
  end
end
