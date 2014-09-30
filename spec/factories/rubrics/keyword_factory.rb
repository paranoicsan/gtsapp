FactoryGirl.define do

  factory :keyword, class: Rubrics::Keyword do
    name { Faker::Lorem.words(1).join }
  end

end