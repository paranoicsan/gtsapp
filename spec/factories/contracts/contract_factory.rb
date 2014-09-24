FactoryGirl.define do

  factory :contract, class: Contracts::Contract do

    trait :active do
      association :status, factory: [:contract_status_active]
    end

    date_sign { Date.today }
    number { Faker::Lorem.words(3).join(' ') }
    amount 100

    active
    association :code, factory: [:contract_code]
    association :company, factory: [:company]

    factory :contract_active do
      active
    end
    factory :contract_suspended do
      status { FactoryGirl.create :contract_status_suspended }
    end

  end

end