# Encoding: utf-8
class GetStatusDeleteBack < ActiveRecord::Migration
  def change
    s = 'На удалении'
    unless Status.find_by_name(s)
      Status.create(name: s).save!
    end
  end
end
