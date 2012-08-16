class AddPerson < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :position
      t.string :name
      t.string :second_name
      t.string :middle_name
      t.integer :phone
      t.string :email
      t.integer :company_id
    end

    add_foreign_key :people, :companies
  end
end
