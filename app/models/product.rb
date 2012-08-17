class Product < ActiveRecord::Base
  belongs_to :product_type, :foreign_key => 'product_id'
  belongs_to :contract
  validates_presence_of :product_id, :contract_id
end
