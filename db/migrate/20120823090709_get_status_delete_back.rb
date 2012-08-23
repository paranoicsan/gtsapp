# Encoding: utf-8
class GetStatusDeleteBack < ActiveRecord::Migration
  def change
    s = 'На удалении'
    unless CompanyStatus.find_by_name(s)
      CompanyStatus.create(name: s).save!
    end
  end
end
