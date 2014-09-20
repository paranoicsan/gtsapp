require 'faker'

FactoryGirl.define do
  factory :product_type do
    name { Faker::Lorem.words.join(' ') }
  end
end
