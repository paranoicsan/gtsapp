require "faker"

FactoryGirl.define do

  factory :contract do
    number { Faker::Lorem.words(3).join(' ') }
    amount 100
    contract_status
  end

end