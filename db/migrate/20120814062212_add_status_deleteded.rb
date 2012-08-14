# Encoding: utf-8
class AddStatusDeleteded < ActiveRecord::Migration
  def change
    CompanyStatus.create(name: 'На удалении').save!
  end
end
