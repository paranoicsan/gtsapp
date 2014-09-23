# Encoding: utf-8
class AddStatusDeleteded < ActiveRecord::Migration
  def change
    Status.create(name: 'На удалении').save!
  end
end
