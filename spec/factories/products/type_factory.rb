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

FactoryGirl.define do
  factory :product_type, class: Products::Type do
    name { Faker::Lorem.words.join(' ') }
  end
end
