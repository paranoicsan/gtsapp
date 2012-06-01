class CompanyWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :name
    end

    create_table :branch_websites do |t|
      t.integer :website_id
      t.integer :branch_id
    end

    add_foreign_key :branch_websites, :branches
    add_foreign_key :branch_websites, :websites
  end
end
