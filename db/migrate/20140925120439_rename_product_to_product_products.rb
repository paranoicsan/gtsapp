class RenameProductToProductProducts < ActiveRecord::Migration
  def change
    rename_table :products, :products_products
    rename_column :products_products, :product_id, :type_id
  end
end
