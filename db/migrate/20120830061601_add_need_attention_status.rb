# Encoding: utf-8
class AddNeedAttentionStatus < ActiveRecord::Migration
  def change
    ['Требует внимания'].each do |s|
      unless Status.find_by_name(s)
        Status.create(name: s).save!
      end
    end
  end
end
