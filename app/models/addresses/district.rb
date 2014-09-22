class Addresses::District < ActiveRecord::Base
  has_many :addresses
end
