require "faker"

FactoryGirl.define do

  factory :contract do
    number { Faker::Lorem.words(3).join(' ') }
    amount 100
    contract_status
    project_code { FactoryGirl.create :project_code }
    company { FactoryGirl.create :company }

    factory :contract_active do
      contract_status { FactoryGirl.create :contract_status_active }
    end
    factory :contract_suspended do
      contract_status { FactoryGirl.create :contract_status_suspended }
    end

  end

end