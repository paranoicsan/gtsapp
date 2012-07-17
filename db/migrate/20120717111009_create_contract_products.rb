class CreateContractProducts < ActiveRecord::Migration
  def change
    create_table :contract_products do |t|
      t.integer :contract_id
      t.integer :product_id

      t.timestamps
    end

    add_foreign_key :contract_products, :contracts
    add_foreign_key :contract_products, :products
  end
end
