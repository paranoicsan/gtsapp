require 'faker'

FactoryGirl.define do

  factory :rubric do
    name { Faker::Lorem.words.join }
    social true

    factory :rubric_comercial do
      social false
    end

  end

end