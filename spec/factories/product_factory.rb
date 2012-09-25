require "faker"

FactoryGirl.define do
  factory :product do
    proposal { Faker::Lorem.sentence }
    rubric { FactoryGirl.create :rubric}
    contract { FactoryGirl.create :contract }
    product_id { FactoryGirl.create(:product_type).id }
  end
end
