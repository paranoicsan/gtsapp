class RenameContractProductToProduct < ActiveRecord::Migration
  def change
    rename_table :contract_products, :products
  end
end
