class MoveAddressObjectsToModule < ActiveRecord::Migration
  def change
    rename_table :cities, :addresses_cities
    rename_table :districts, :addresses_districts
    rename_table :post_indices, :addresses_post_indices
    rename_table :streets, :addresses_streets
    rename_table :street_indices, :addresses_street_indices
  end
end
