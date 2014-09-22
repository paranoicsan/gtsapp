class RemoveAllOldId < ActiveRecord::Migration
  def up
    remove_column :addresses, :old_id
    remove_column :branches, :old_id    
    remove_column :branches, :old_company_id
    remove_column :cities, :old_id
    remove_column :companies, :old_id
    remove_column :contracts, :old_company_id
    remove_column :districts, :old_id
    remove_column :emails, :old_branch_id
    remove_column :form_types, :old_id
    remove_column :keywords, :old_id
    remove_column :people, :old_company_id
    remove_column :phones, :old_branch_id
    remove_column :phones, :old_id
    remove_column :post_indices, :old_id
    remove_column :rubrics, :old_id
    remove_column :streets, :old_id    
  end

  def down
    add_column :addresses, :old_id, :integer
    add_column :branches, :old_id, :integer
    add_column :branches, :old_company_id, :integer
    add_column :cities, :old_id, :integer
    add_column :companies, :old_id, :integer
    add_column :contracts, :old_company_id, :integer
    add_column :districts, :old_id, :integer
    add_column :emails, :old_branch_id, :integer
    add_column :form_types, :old_id, :integer
    add_column :keywords, :old_id, :integer
    add_column :people, :old_company_id, :integer
    add_column :phones, :old_branch_id, :integer
    add_column :phones, :old_id, :integer
    add_column :post_indices, :old_id, :integer
    add_column :rubrics, :old_id, :integer
    add_column :streets, :old_id, :integer
  end
end
