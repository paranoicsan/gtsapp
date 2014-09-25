FactoryGirl.define do
  factory :product_type, class: Products::Type do
    name { Faker::Lorem.words.join(' ') }
  end
end
