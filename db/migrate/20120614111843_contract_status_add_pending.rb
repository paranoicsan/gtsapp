# encoding: utf-8
class ContractStatusAddPending < ActiveRecord::Migration
  def change
    Status.create(name: 'на рассмотрении').save!
  end
end
