class City < ActiveRecord::Base

  has_many :streets
  has_many :addresses

  validates_presence_of :name,
                        :phone_code

  attr_accessible :name, :phone_code

end
