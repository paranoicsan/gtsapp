class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :name
      t.integer :branch_id

      t.timestamps
    end

    add_foreign_key :emails, :branches
  end
end
