class MoveBranchObjectsToModule < ActiveRecord::Migration
  def change
    rename_table :branches_websites, :branches_websites_join
    rename_table :branches, :branches_branches
    rename_table :emails, :branches_emails
    rename_table :form_types, :branches_form_types
    rename_table :phones, :branches_phones
    rename_table :websites, :branches_websites
  end
end
