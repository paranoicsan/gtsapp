class Street < ActiveRecord::Base
  belongs_to :city
  has_many :street_indexes
end
