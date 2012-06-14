# encoding: utf-8
class ContractStatus < ActiveRecord::Base
  has_many :contracts

  def self.active
    ContractStatus.find_by_name "активен"
  end

  def self.inactive
    ContractStatus.find_by_name "не активен"
  end

  def self.pending
    ContractStatus.find_by_name "на рассмотрении"
  end

end
