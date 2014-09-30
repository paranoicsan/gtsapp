class MoveRubricsToModule < ActiveRecord::Migration
  def change
    rename_table :rubrics, :rubrics_rubrics
    rename_table :keywords, :rubrics_keywords
    rename_table :keywords_rubrics, :rubrics_keywords_join
    rename_table :companies_rubrics, :companies_rubrics_join
  end
end
