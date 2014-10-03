# == Schema Information
#
# Table name: addresses_streets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_addresses_streets_on_id  (id)
#

FactoryGirl.define do
  factory :street, class: Addresses::Street do
    name { Faker::Address.street_name }
    city_id { FactoryGirl.create(:city).id }
  end

end
