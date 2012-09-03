# Encoding: utf-8
class AddSecondSuspendStatus < ActiveRecord::Migration
  def change
    ['Повторное рассмотрение'].each do |s|
      unless CompanyStatus.find_by_name(s)
        CompanyStatus.create(name: s).save!
      end
    end
  end
end
