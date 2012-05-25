class AddRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.integer :old_id
      t.string :name
      t.boolean :social
    end

    create_table :keywords do |t|
      t.integer :old_id
      t.string :name
    end

    create_table :rubric_keywords do |t|
      t.integer :rubric_id
      t.integer :keyword_id
    end
    add_foreign_key :rubric_keywords, :rubrics
    add_foreign_key :rubric_keywords, :keywords

    create_table :company_rubrics do |t|
      t.integer :company_id
      t.integer :rubric_id
    end
    add_foreign_key :company_rubrics, :rubrics
    add_foreign_key :company_rubrics, :companies
  end
end
