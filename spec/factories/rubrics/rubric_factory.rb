FactoryGirl.define do

  factory :rubric, class: Rubrics::Rubric do
    name { Faker::Lorem.words.join }
    social true

    factory :rubric_comercial do
      social false
    end

  end

end