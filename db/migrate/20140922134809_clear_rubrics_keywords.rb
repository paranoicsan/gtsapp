class ClearRubricsKeywords < ActiveRecord::Migration
  def up
    remove_column :rubric_keywords, :id
    rename_table :rubric_keywords, :keywords_rubrics
  end

  def down
    rename_table :keywords_rubrics, :rubric_keywords
    add_column :rubric_keywords, :id, :integer
  end
end
