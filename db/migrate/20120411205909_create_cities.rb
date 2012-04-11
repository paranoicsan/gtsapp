class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :phone_code
      t.integer :old_id

      t.timestamps
    end
  end
end
