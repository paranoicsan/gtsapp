class AddOldBranchIdToBranchWebsite < ActiveRecord::Migration
  def change
    add_column :branch_websites, :old_branch_id, :integer
  end
end
