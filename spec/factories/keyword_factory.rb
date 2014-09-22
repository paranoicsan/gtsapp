FactoryGirl.define do

  factory :keyword do
    name { Faker::Lorem.words(1).join }
  end

end