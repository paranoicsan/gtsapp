class CompanySourceFrom < ActiveRecord::Migration
  def change
    create_table :company_sources do |t|
      t.string :name
    end

    add_column :companies, :company_source_id, :integer
    add_foreign_key :companies, :company_sources
  end
end
