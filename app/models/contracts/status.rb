# == Schema Information
#
# Table name: contracts_statuses
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_contracts_statuses_on_id  (id)
#

class Contracts::Status < ActiveRecord::Base

  has_many :contracts

  ACTIVE = 'активен'
  INACTIVE = 'не активен'
  PENDING  = 'на рассмотрении'

  def self.active
    find_by_name ACTIVE
  end

  def self.inactive
    find_by_name INACTIVE
  end

  def self.pending
    find_by_name PENDING
  end

end
