# == Schema Information
#
# Table name: contracts_codes
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Contracts::Code < ActiveRecord::Base
  has_many :contracts
end
