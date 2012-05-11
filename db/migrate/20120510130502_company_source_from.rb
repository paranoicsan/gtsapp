# encoding: utf-8
class CompanySourceFrom < ActiveRecord::Migration
  def change
    create_table :company_sources do |t|
      t.string :name
    end

    add_column :companies, :company_source_id, :integer
    add_foreign_key :companies, :company_sources

    CompanySource.create(name: "Заявка с сайта").save!
    CompanySource.create(name: "От агента").save!

  end

end
