FactoryGirl.define do

  factory :contract_code, class: Contracts::Code do
    name { Faker::Lorem.words(1).join() }
  end

end