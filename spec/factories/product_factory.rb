require 'faker'

FactoryGirl.define do
  factory :product do
    proposal { Faker::Lorem.sentence }
    rubric
    contract
    #product_id { FactoryGirl.create(:product_type).id }
    product_type { FactoryGirl.create(:product_type) }
  end
end
