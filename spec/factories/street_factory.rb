require "faker"

FactoryGirl.define do

  factory :street do
    name { Faker::Address.street_name }
    city_id { FactoryGirl.create(:city).id }
  end

end