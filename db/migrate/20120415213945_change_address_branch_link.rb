class ChangeAddressBranchLink < ActiveRecord::Migration
  def change
    remove_foreign_key :branches, :addresses
    add_column :addresses, :branch_id, :integer
    remove_column :branches, :address_id
    add_foreign_key :addresses, :branches
  end
end
