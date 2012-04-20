class StreetIndex < ActiveRecord::Base
  belongs_to :street
  belongs_to :post_index
end
