require 'faker'

FactoryGirl.define do

  factory :keyword do
    name { Faker::Lorem.words(1).join }
    rubric { FactoryGirl.create :rubric }
  end

end