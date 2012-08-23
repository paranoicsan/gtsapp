# Encoding: utf-8
class GetAllStatusesBack < ActiveRecord::Migration
  def change
    ['Активна', 'На рассмотрении', 'В архиве'].each do |s|
      unless CompanyStatus.find_by_name(s)
        CompanyStatus.create(name: s).save!
      end
    end
  end
end
