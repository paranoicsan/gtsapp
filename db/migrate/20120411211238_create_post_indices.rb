class CreatePostIndices < ActiveRecord::Migration
  def change
    create_table :post_indices do |t|
      t.integer :code
      t.integer :old_id

      t.timestamps
    end
  end
end
