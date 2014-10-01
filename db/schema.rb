# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141001082741) do

  create_table "addresses_addresses", :force => true do |t|
    t.string   "house"
    t.string   "entrance"
    t.string   "case"
    t.string   "stage"
    t.string   "office"
    t.string   "cabinet"
    t.string   "other"
    t.string   "pavilion"
    t.string   "litera"
    t.integer  "district_id"
    t.integer  "city_id"
    t.integer  "street_id"
    t.integer  "post_index_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "addresses_cities", :force => true do |t|
    t.string   "name"
    t.integer  "phone_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "addresses_districts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "addresses_post_indices", :force => true do |t|
    t.integer  "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "addresses_street_indices", :force => true do |t|
    t.integer "street_id"
    t.integer "post_index_id"
    t.string  "comments"
  end

  create_table "addresses_streets", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "branches_branches", :force => true do |t|
    t.integer  "form_type_id"
    t.string   "fact_name"
    t.string   "legel_name"
    t.integer  "company_id"
    t.string   "comments"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "is_main"
  end

  create_table "branches_emails", :force => true do |t|
    t.string   "name"
    t.integer  "branch_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "branches_form_types", :force => true do |t|
    t.string "name"
  end

  create_table "branches_phones", :force => true do |t|
    t.string   "mobile_refix"
    t.boolean  "publishable"
    t.boolean  "fax"
    t.boolean  "director"
    t.boolean  "mobile"
    t.text     "description"
    t.string   "name"
    t.integer  "contact"
    t.integer  "order_num"
    t.integer  "branch_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "branches_websites", :force => true do |t|
    t.string "name"
  end

  create_table "branches_websites_join", :id => false, :force => true do |t|
    t.integer "website_id"
    t.integer "branch_id"
  end

  create_table "companies_companies", :force => true do |t|
    t.string   "title"
    t.date     "date_added"
    t.integer  "rubricator"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "companies_status_id"
    t.integer  "author_user_id"
    t.integer  "editor_user_id"
    t.integer  "companies_source_id"
    t.integer  "agent_id"
    t.string   "comments"
    t.string   "reason_deleted_on"
    t.string   "reason_need_attention_on"
    t.string   "reason_need_improvement_on"
  end

  create_table "companies_histories", :force => true do |t|
    t.text     "operation"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "companies_people", :force => true do |t|
    t.string  "position"
    t.string  "name"
    t.string  "second_name"
    t.string  "middle_name"
    t.integer "phone",       :limit => 8
    t.string  "email"
    t.integer "company_id"
  end

  create_table "companies_rubrics_join", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "rubric_id"
  end

  create_table "companies_sources", :force => true do |t|
    t.string "name"
  end

  create_table "companies_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contracts_codes", :force => true do |t|
    t.string "name"
  end

  create_table "contracts_contracts", :force => true do |t|
    t.integer  "contracts_statuses_id"
    t.integer  "contracts_codes_id"
    t.date     "date_sign"
    t.string   "number"
    t.float    "amount"
    t.boolean  "bonus"
    t.string   "company_legel_name"
    t.string   "person"
    t.string   "company_details"
    t.integer  "number_of_dicts"
    t.integer  "company_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "contracts_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "products_products", :force => true do |t|
    t.integer  "contract_id"
    t.integer  "type_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "rubric_id"
    t.text     "proposal"
  end

  create_table "products_types", :force => true do |t|
    t.string   "name"
    t.float    "size_width"
    t.float    "size_height"
    t.integer  "bonus_type_id"
    t.string   "bonus_site"
    t.float    "price"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "rubrics_keywords", :force => true do |t|
    t.string "name"
  end

  create_table "rubrics_keywords_join", :id => false, :force => true do |t|
    t.integer "rubric_id"
    t.integer "keyword_id"
  end

  create_table "rubrics_rubrics", :force => true do |t|
    t.string  "name"
    t.boolean "social"
  end

  create_table "users_users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "roles",                  :default => "--- []"
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
  end

  add_index "users_users", ["email"], :name => "index_users_users_on_email", :unique => true
  add_index "users_users", ["reset_password_token"], :name => "index_users_users_on_reset_password_token", :unique => true

  add_foreign_key "addresses_addresses", "addresses_cities", :name => "addresses_city_id_fk", :column => "city_id"
  add_foreign_key "addresses_addresses", "addresses_districts", :name => "addresses_district_id_fk", :column => "district_id"
  add_foreign_key "addresses_addresses", "addresses_post_indices", :name => "addresses_post_index_id_fk", :column => "post_index_id"
  add_foreign_key "addresses_addresses", "addresses_streets", :name => "addresses_street_id_fk", :column => "street_id"
  add_foreign_key "addresses_addresses", "branches_branches", :name => "addresses_branch_id_fk", :column => "branch_id"

  add_foreign_key "addresses_street_indices", "addresses_post_indices", :name => "street_indices_post_index_id_fk", :column => "post_index_id"
  add_foreign_key "addresses_street_indices", "addresses_streets", :name => "street_indices_street_id_fk", :column => "street_id"

  add_foreign_key "addresses_streets", "addresses_cities", :name => "streets_city_id_fk", :column => "city_id"

  add_foreign_key "branches_branches", "branches_form_types", :name => "branches_form_type_id_fk", :column => "form_type_id"
  add_foreign_key "branches_branches", "companies_companies", :name => "branches_company_id_fk", :column => "company_id"

  add_foreign_key "branches_emails", "branches_branches", :name => "emails_branch_id_fk", :column => "branch_id"

  add_foreign_key "branches_phones", "branches_branches", :name => "phones_branch_id_fk", :column => "branch_id"

  add_foreign_key "branches_websites_join", "branches_branches", :name => "branch_websites_branch_id_fk", :column => "branch_id"
  add_foreign_key "branches_websites_join", "branches_websites", :name => "branch_websites_website_id_fk", :column => "website_id"

  add_foreign_key "companies_companies", "companies_sources", :name => "companies_company_source_id_fk"
  add_foreign_key "companies_companies", "companies_statuses", :name => "companies_companies_companies_status_id_fk"
  add_foreign_key "companies_companies", "users_users", :name => "companies_agent_id_fk", :column => "agent_id"
  add_foreign_key "companies_companies", "users_users", :name => "companies_author_user_id_fk", :column => "author_user_id"
  add_foreign_key "companies_companies", "users_users", :name => "companies_editor_user_id_fk", :column => "editor_user_id"

  add_foreign_key "companies_histories", "companies_companies", :name => "company_histories_company_id_fk", :column => "company_id"
  add_foreign_key "companies_histories", "users_users", :name => "company_histories_user_id_fk", :column => "user_id"

  add_foreign_key "companies_people", "companies_companies", :name => "people_company_id_fk", :column => "company_id"

  add_foreign_key "companies_rubrics_join", "companies_companies", :name => "company_rubrics_company_id_fk", :column => "company_id"
  add_foreign_key "companies_rubrics_join", "rubrics_rubrics", :name => "company_rubrics_rubric_id_fk", :column => "rubric_id"

  add_foreign_key "contracts_contracts", "companies_companies", :name => "contracts_company_id_fk", :column => "company_id"
  add_foreign_key "contracts_contracts", "contracts_codes", :name => "contracts_project_code_id_fk", :column => "contracts_codes_id"
  add_foreign_key "contracts_contracts", "contracts_statuses", :name => "contracts_contract_status_id_fk", :column => "contracts_statuses_id"

  add_foreign_key "products_products", "contracts_contracts", :name => "contract_products_contract_id_fk", :column => "contract_id"
  add_foreign_key "products_products", "products_types", :name => "contract_products_product_id_fk", :column => "type_id"
  add_foreign_key "products_products", "rubrics_rubrics", :name => "products_rubric_id_fk", :column => "rubric_id"

  add_foreign_key "products_types", "products_types", :name => "products_bonus_product_id_fk", :column => "bonus_type_id"

  add_foreign_key "rubrics_keywords_join", "rubrics_keywords", :name => "rubric_keywords_keyword_id_fk", :column => "keyword_id"
  add_foreign_key "rubrics_keywords_join", "rubrics_rubrics", :name => "rubric_keywords_rubric_id_fk", :column => "rubric_id"

end
