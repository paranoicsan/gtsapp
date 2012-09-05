require "faker"

FactoryGirl.define do

  factory :website do
    name Faker::Internet.url
  end

end