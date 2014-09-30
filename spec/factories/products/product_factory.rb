FactoryGirl.define do
  factory :product, class: Products::Product do
    proposal { Faker::Lorem.sentence }
    association :rubric, factory: :rubric
    association :contract, factory: :contract
    association :type, factory: :product_type
  end
end
