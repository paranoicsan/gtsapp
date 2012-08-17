class ExtendProduct < ActiveRecord::Migration
  def change
    add_column :products, :rubric_id, :integer
    add_column :products, :proposal, :text
    add_foreign_key :products, :rubrics
  end


end
