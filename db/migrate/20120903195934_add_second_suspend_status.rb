# Encoding: utf-8
class AddSecondSuspendStatus < ActiveRecord::Migration
  def change
    ['Повторное рассмотрение'].each do |s|
      unless Status.find_by_name(s)
        Status.create(name: s).save!
      end
    end
  end
end
