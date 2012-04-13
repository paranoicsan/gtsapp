# encoding: utf-8
class CreateCompanyStatuses < ActiveRecord::Migration
  def change
    create_table "company_statuses", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_column :companies, :company_status_id, :integer

  end
end
