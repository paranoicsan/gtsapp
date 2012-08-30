# Encoding: utf-8
class AddNeedAttentionStatus < ActiveRecord::Migration
  def change
    ['Требует внимания'].each do |s|
      unless CompanyStatus.find_by_name(s)
        CompanyStatus.create(name: s).save!
      end
    end
  end
end
