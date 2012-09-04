require "faker"

FactoryGirl.define do
  factory :company_history do
    username Faker::Internet.user_name
    operation Faker::Lorem.words(1).join
    company
  end
end
