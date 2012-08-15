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

ActiveRecord::Schema.define(:version => 20120814201845) do

  create_table "addresses", :force => true do |t|
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

  create_table "branch_websites", :force => true do |t|
    t.integer "website_id"
    t.integer "branch_id"
  end

  create_table "branches", :force => true do |t|
    t.integer  "form_type_id"
    t.string   "fact_name"
    t.string   "legel_name"
    t.integer  "company_id"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_main"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "phone_code"
    t.integer  "old_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "title"
    t.date     "date_added"
    t.integer  "rubricator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_status_id"
    t.integer  "author_user_id"
    t.integer  "editor_user_id"
    t.integer  "company_source_id"
    t.integer  "agent_id"
    t.string   "comments"
    t.string   "reason_deleted_on"
  end

  create_table "company_rubrics", :force => true do |t|
    t.integer "company_id"
    t.integer "rubric_id"
  end

  create_table "company_sources", :force => true do |t|
    t.string "name"
  end

  create_table "company_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contract_products", :force => true do |t|
    t.integer  "contract_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contract_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "contracts", :force => true do |t|
    t.integer  "contract_status_id"
    t.integer  "project_code_id"
    t.date     "date_sign"
    t.string   "number"
    t.float    "amount"
    t.boolean  "bonus"
    t.string   "company_legel_name"
    t.string   "person"
    t.string   "company_details"
    t.integer  "number_of_dicts"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "old_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string   "name"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "form_types", :force => true do |t|
    t.string  "name"
    t.integer "old_id"
  end

  create_table "keywords", :force => true do |t|
    t.integer "old_id"
    t.string  "name"
  end

  create_table "phones", :force => true do |t|
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
    t.integer  "old_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_indices", :force => true do |t|
    t.integer  "code"
    t.integer  "old_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.float    "size_width"
    t.float    "size_height"
    t.integer  "bonus_product_id"
    t.string   "bonus_site"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_codes", :force => true do |t|
    t.string "name"
  end

  create_table "rubric_keywords", :force => true do |t|
    t.integer "rubric_id"
    t.integer "keyword_id"
  end

  create_table "rubrics", :force => true do |t|
    t.integer "old_id"
    t.string  "name"
    t.boolean "social"
  end

  create_table "street_indices", :force => true do |t|
    t.integer "street_id"
    t.integer "post_index_id"
    t.string  "comments"
  end

  create_table "streets", :force => true do |t|
    t.string   "name"
    t.integer  "old_id"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles",             :default => "--- []"
  end

  create_table "websites", :force => true do |t|
    t.string "name"
  end

  add_foreign_key "addresses", "branches", :name => "addresses_branch_id_fk"
  add_foreign_key "addresses", "cities", :name => "addresses_city_id_fk"
  add_foreign_key "addresses", "districts", :name => "addresses_district_id_fk"
  add_foreign_key "addresses", "post_indices", :name => "addresses_post_index_id_fk"
  add_foreign_key "addresses", "streets", :name => "addresses_street_id_fk"

  add_foreign_key "branch_websites", "branches", :name => "branch_websites_branch_id_fk"
  add_foreign_key "branch_websites", "websites", :name => "branch_websites_website_id_fk"

  add_foreign_key "branches", "companies", :name => "branches_company_id_fk"
  add_foreign_key "branches", "form_types", :name => "branches_form_type_id_fk"

  add_foreign_key "companies", "company_sources", :name => "companies_company_source_id_fk"
  add_foreign_key "companies", "users", :name => "companies_agent_id_fk", :column => "agent_id"
  add_foreign_key "companies", "users", :name => "companies_author_user_id_fk", :column => "author_user_id"
  add_foreign_key "companies", "users", :name => "companies_editor_user_id_fk", :column => "editor_user_id"

  add_foreign_key "company_rubrics", "companies", :name => "company_rubrics_company_id_fk"
  add_foreign_key "company_rubrics", "rubrics", :name => "company_rubrics_rubric_id_fk"

  add_foreign_key "contract_products", "contracts", :name => "contract_products_contract_id_fk"
  add_foreign_key "contract_products", "products", :name => "contract_products_product_id_fk"

  add_foreign_key "contracts", "companies", :name => "contracts_company_id_fk"
  add_foreign_key "contracts", "contract_statuses", :name => "contracts_contract_status_id_fk"
  add_foreign_key "contracts", "project_codes", :name => "contracts_project_code_id_fk"

  add_foreign_key "emails", "branches", :name => "emails_branch_id_fk"

  add_foreign_key "phones", "branches", :name => "phones_branch_id_fk"

  add_foreign_key "products", "products", :name => "products_bonus_product_id_fk", :column => "bonus_product_id"

  add_foreign_key "rubric_keywords", "keywords", :name => "rubric_keywords_keyword_id_fk"
  add_foreign_key "rubric_keywords", "rubrics", :name => "rubric_keywords_rubric_id_fk"

  add_foreign_key "street_indices", "post_indices", :name => "street_indices_post_index_id_fk"
  add_foreign_key "street_indices", "streets", :name => "street_indices_street_id_fk"

  add_foreign_key "streets", "cities", :name => "streets_city_id_fk"

end
