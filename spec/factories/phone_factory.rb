require "faker"

FactoryGirl.define do

  factory :phone do
    name { Faker::PhoneNumber.phone_number }
    mobile false
    contact false
    description { Faker::Lorem.words(1).join() }
    director false
    fax false
    mobile_refix 921
    branch { FactoryGirl.create :branch }
  end

end