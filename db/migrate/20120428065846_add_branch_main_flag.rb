class AddBranchMainFlag < ActiveRecord::Migration
  def change
    add_column :branches, :is_main, :boolean
  end
end
