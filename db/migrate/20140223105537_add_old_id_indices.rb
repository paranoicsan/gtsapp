class AddOldIdIndices < ActiveRecord::Migration
  def change

    [:address, :branches, :companies, :form_types, :rubrics].each do |table|
      add_index table, :old_id
    end

  end
end
