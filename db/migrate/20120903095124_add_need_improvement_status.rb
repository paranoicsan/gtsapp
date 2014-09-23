# Encoding: utf-8
class AddNeedImprovementStatus < ActiveRecord::Migration
  def change
    ['Требует доработки'].each do |s|
      unless Status.find_by_name(s)
        Status.create(name: s).save!
      end
    end
  end
end
