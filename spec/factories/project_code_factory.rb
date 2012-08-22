require "faker"

FactoryGirl.define do

  factory :project_code do
    name { Faker::Lorem.words(1).join() }
  end

end