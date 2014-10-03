# == Schema Information
#
# Table name: contracts_contracts
#
#  id                    :integer          not null, primary key
#  contracts_statuses_id :integer
#  contracts_codes_id    :integer
#  date_sign             :date
#  number                :string(255)
#  amount                :float
#  bonus                 :boolean
#  company_legel_name    :string(255)
#  person                :string(255)
#  company_details       :string(255)
#  number_of_dicts       :integer
#  company_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_contracts_contracts_on_id  (id)
#

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
