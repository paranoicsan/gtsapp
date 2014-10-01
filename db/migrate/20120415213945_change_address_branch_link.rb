class ChangeAddressBranchLink < ActiveRecord::Migration
  def change
    remove_foreign_key :branches, :address
    add_column :addresses, :branch_id, :integer
    remove_column :branches, :address_id
    add_foreign_key :address, :branches
  end
end
