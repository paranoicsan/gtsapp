require 'faker'

FactoryGirl.define do
  factory :product do
    proposal { Faker::Lorem.sentence }
    rubric
    association :contract, factory: :contract
    product_type
  end
end
