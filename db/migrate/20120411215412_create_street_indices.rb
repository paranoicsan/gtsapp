class CreateStreetIndices < ActiveRecord::Migration
  def change
    create_table :street_indices do |t|
      t.integer :street_id
      t.integer :post_index_id
      t.string :comments
    end

    add_foreign_key :street_indices, :streets
    add_foreign_key :street_indices, :post_indices
  end
end
