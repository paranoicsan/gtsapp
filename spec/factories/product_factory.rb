require 'faker'

FactoryGirl.define do
  factory :product do
    proposal { Faker::Lorem.sentence }
    rubric
    contract
    product_type
  end
end
