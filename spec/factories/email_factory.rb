require "faker"

FactoryGirl.define do

  factory :email do
    name { Faker::Internet.email }
  end

end