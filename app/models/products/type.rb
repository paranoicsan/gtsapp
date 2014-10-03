# == Schema Information
#
# Table name: products_types
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  size_width    :float
#  size_height   :float
#  bonus_type_id :integer
#  bonus_site    :string(255)
#  price         :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_products_types_on_id  (id)
#

class Products::Type < ActiveRecord::Base
  has_many :products
  has_one :bonus_type, class_name: 'Products::Type', foreign_key: 'bonus_type_id'

  validates_presence_of :name

end
