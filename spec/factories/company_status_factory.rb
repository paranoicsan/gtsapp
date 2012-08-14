# Encoding: utf-8

FactoryGirl.define do

  factory :company_status do
    name "Неизвестно"

    factory :company_status_active do
      name "Активна"
    end

    factory :company_status_suspended do
      name "На рассмотрении"
    end

    factory :company_status_archived do
      name "В архиве"
    end

    factory :company_status_on_deletion do
      name "На удалении"
    end

  end

end