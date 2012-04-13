class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string   :house
      t.string   :entrance
      t.string   :case
      t.string   :stage
      t.string   :office
      t.string   :cabinet
      t.string   :other
      t.string   :pavilion
      t.string   :litera
      t.integer  :district_id
      t.integer  :city_id
      t.integer  :street_id
      t.integer  :post_index_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_foreign_key :addresses, :streets
    add_foreign_key :addresses, :districts
    add_foreign_key :addresses, :cities
    add_foreign_key :addresses, :post_indices

  end
end
