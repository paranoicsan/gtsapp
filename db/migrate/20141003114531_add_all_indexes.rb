class AddAllIndexes < ActiveRecord::Migration
  def change

    add_index :branches_websites, :id
    add_index :branches_emails, :id
    add_index :branches_phones, :id
    add_index :companies_histories, :id
    add_index :contracts_statuses, :id
    add_index :contracts_codes, :id
    add_index :rubrics_keywords, :id
    add_index :companies_sources, :id
    add_index :companies_statuses, :id
    add_index :companies_people, :id
    add_index :products_types, :id
    add_index :addresses_districts, :id
    add_index :contracts_contracts, :id
    add_index :products_products, :id
    add_index :branches_branches, :id
    add_index :addresses_addresses, :id
    add_index :addresses_post_indices, :id
    add_index :rubrics_rubrics, :id
    add_index :addresses_street_indices, :id
    add_index :addresses_cities, :id
    add_index :addresses_streets, :id
    add_index :branches_form_types, :id
    add_index :companies_companies, :id
    add_index :users_users, :id

  end
end
