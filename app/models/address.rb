class Address < ActiveRecord::Base
  belongs_to :district
  belongs_to :city
  belongs_to :street
  belongs_to :post_index
end
