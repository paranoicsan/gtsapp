require "faker"

FactoryGirl.define do
  factory :company_history do
    user
    operation Faker::Lorem.words(1).join
    company
  end
end
