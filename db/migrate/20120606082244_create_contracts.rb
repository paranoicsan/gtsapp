class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contract_statuses do |t|
      t.string name
    end

    create_table :project_codes do |t|
      t.string name
    end

    create_table :contracts do |t|
      t.integer :contract_status_id
      t.integer :project_code_id
      t.date :date_sign
      t.string :number
      t.integer :amount
      t.boolean :bonus
      t.string :company_legel_name
      t.string :person
      t.string :company_details
      t.integer :number_of_dicts
      t.integer :company_id
      t.timestamps
    end

    add_foreign_key :contracts, :companies
    add_foreign_key :contracts, :project_codes
    add_foreign_key :contracts, :contract_statuses
  end
end
