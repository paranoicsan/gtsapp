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

FactoryGirl.define do
  factory :city, class: Addresses::City do
    name { Faker::Address.city }
    phone_code 4012
  end

end
