class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :form_type_id
      t.string :fact_name
      t.string :legel_name
      t.integer :company_id
      t.integer :address_id
      t.string :comments

      t.timestamps
    end

    add_foreign_key :branches, :form_types
    add_foreign_key :branches, :companies
    add_foreign_key :branches, :address
  end
end
