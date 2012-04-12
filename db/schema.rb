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

ActiveRecord::Schema.define(:version => 20120412163648) do

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
  end

  create_table "company_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "old_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "form_types", :force => true do |t|
    t.string  "name"
    t.integer "old_id"
  end

  create_table "post_indices", :force => true do |t|
    t.integer  "code"
    t.integer  "old_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

end
