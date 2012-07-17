class ContractProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :contract
  validates_presence_of :product_id, :contract_id
end
