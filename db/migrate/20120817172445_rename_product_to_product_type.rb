class RenameProductToProductType < ActiveRecord::Migration
  def change
    rename_table :products, :product_types
  end
end
