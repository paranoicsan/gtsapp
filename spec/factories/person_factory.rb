require "faker"

FactoryGirl.define do
  factory :person do
    position { Faker::Name.title }
    name { Faker::Name.name }
    second_name { Faker::Name.last_name }
    middle_name { Faker::Name.suffix }
    phone 1234567
    email { Faker::Internet.email }
  end
end
