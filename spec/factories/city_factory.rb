require "faker"

FactoryGirl.define do

  factory :city do
    name { Faker::Address.city }
    phone_code "4012"
  end

end