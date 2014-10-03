# == Schema Information
#
# Table name: contracts_statuses
#
#  id   :integer          not null, primary key
#  name :string(255)
#

FactoryGirl.define do

  factory :contract_status, class: Contracts::Status do
    name Contracts::Status::PENDING

    factory :contract_status_active do
      name Contracts::Status::ACTIVE
    end

    factory :contract_status_suspended do
      name Contracts::Status::PENDING
    end

    factory :contract_status_inactive do
      name Contracts::Status::INACTIVE
    end

  end

end
