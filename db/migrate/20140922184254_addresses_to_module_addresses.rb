class AddressesToModuleAddresses < ActiveRecord::Migration
  def change
    rename_table :addresses, :addresses_addresses
  end
end
