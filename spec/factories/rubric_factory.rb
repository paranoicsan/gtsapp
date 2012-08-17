require 'faker'

FactoryGirl.define do

  factory :rubric do
    name { Faker::Lorem.words(1).join }
    social true

    factory :rubric_comercial do
      social false
    end

  end

end