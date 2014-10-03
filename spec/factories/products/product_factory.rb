# == Schema Information
#
# Table name: products_products
#
#  id          :integer          not null, primary key
#  contract_id :integer
#  type_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rubric_id   :integer
#  proposal    :text
#

FactoryGirl.define do
  factory :product, class: Products::Product do
    proposal { Faker::Lorem.sentence }
    association :rubric, factory: :rubric
    association :contract, factory: :contract
    association :type, factory: :product_type
  end
end
