class CreateCompanyHistories < ActiveRecord::Migration
  def change
    create_table :company_histories do |t|
      t.string :username
      t.text :operation
      t.integer :company_id
      t.timestamps
    end
    add_foreign_key :company_histories, :companies
  end
end
