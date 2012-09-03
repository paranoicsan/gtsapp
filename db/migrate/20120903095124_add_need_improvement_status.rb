# Encoding: utf-8
class AddNeedImprovementStatus < ActiveRecord::Migration
  def change
    ['Требует доработки'].each do |s|
      unless CompanyStatus.find_by_name(s)
        CompanyStatus.create(name: s).save!
      end
    end
  end
end
