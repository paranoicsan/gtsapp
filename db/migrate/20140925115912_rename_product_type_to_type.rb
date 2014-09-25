class RenameProductTypeToType < ActiveRecord::Migration
  def change
    rename_table :product_types, :products_types
    rename_column :products_types, :bonus_product_id, :bonus_type_id
  end
end
