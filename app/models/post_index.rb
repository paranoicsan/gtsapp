class PostIndex < ActiveRecord::Base
  has_many :street_indexes
  has_many :addresses
end
