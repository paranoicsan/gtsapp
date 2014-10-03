# == Schema Information
#
# Table name: addresses_cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  phone_code :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Addresses::City < ActiveRecord::Base

  has_many :streets
  has_many :addresses

  validates_presence_of :name,
                        :phone_code

  attr_accessible :name, :phone_code, :old_id

end
