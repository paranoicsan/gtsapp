# encoding: utf-8
class CreateCompanyStatuses < ActiveRecord::Migration
  def change
    create_table "company_statuses", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_column :companies, :company_status_id, :integer

    # Статусы компаний
    CompanyStatus.create(name: 'Активна').save!
    CompanyStatus.create(name: 'На рассмотрении').save!
    CompanyStatus.create(name: 'В архиве').save!

  end
end
