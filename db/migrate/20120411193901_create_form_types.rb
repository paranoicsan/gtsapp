class CreateFormTypes < ActiveRecord::Migration
  def change
    create_table :form_types do |t|
      t.string :name
      t.integer :old_id
    end
  end
end
