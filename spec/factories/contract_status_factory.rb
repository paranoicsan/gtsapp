# Encoding: utf-8

FactoryGirl.define do

  factory :contract_status do
    name "на рассмотрении"

    factory :contract_status_active do
      name "активен"
    end

    factory :contract_status_suspended do
      name "на рассмотрении"
    end

    factory :contract_status_inactive do
      name "не активен"
    end

  end

end