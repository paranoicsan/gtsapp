class AddOldBranchIdToPhone < ActiveRecord::Migration
  def change
    add_column :phones, :old_branch_id, :integer
  end
end
