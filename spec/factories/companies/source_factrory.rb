FactoryGirl.define do
  factory :company_source, class: Companies::Source do
    name { Faker::Lorem.words(1).join }
  end
end
