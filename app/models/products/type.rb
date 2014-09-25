class Products::Type < ActiveRecord::Base
  has_many :products
  has_one :bonus_type, class_name: 'Products::Type', foreign_key: 'bonus_type_id'

  validates_presence_of :name

end
