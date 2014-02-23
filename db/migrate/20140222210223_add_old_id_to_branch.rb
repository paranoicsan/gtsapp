class AddOldIdToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :old_id, :integer
  end
end
