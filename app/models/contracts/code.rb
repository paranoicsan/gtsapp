# == Schema Information
#
# Table name: contracts_codes
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_contracts_codes_on_id  (id)
#

class Contracts::Code < ActiveRecord::Base
  has_many :contracts
end
