# encoding: utf-8
class ContractStatusAddPending < ActiveRecord::Migration
  def change
    ContractStatus.create(name: 'на рассмотрении').save!
  end
end
