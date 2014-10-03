# == Schema Information
#
# Table name: addresses_districts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Addresses::District < ActiveRecord::Base
  has_many :addresses
end
