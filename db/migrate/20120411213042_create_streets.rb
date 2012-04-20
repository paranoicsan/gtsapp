class CreateStreets < ActiveRecord::Migration
  def change
    create_table :streets do |t|
      t.string :name
      t.integer :old_id
      t.integer :city_id

      t.timestamps
    end

    add_foreign_key :streets, :cities
  end
end
