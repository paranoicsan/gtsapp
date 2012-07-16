class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.float :size_width
      t.float :size_height
      t.integer :bonus_product_id
      t.string :bonus_site
      t.float :price

      t.timestamps
    end

    add_foreign_key :products, :products, :column => 'bonus_product_id'
  end
end
