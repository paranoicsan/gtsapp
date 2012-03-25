class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :title
      t.date :date_added
      t.integer :rubricator

      t.timestamps
    end
  end
end
