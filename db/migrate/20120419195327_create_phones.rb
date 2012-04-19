class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :mobile_refix
      t.boolean :publishable
      t.boolean :fax
      t.boolean :director
      t.boolean :mobile
      t.text :description
      t.string :name
      t.integer :contact
      t.integer :order_num
      t.integer :branch_id
      t.integer :old_id

      t.timestamps
    end

    add_foreign_key :phones, :branches
  end
end
