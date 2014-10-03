# == Schema Information
#
# Table name: contracts_codes
#
#  id   :integer          not null, primary key
#  name :string(255)
#

FactoryGirl.define do

  factory :contract_code, class: Contracts::Code do
    name { Faker::Lorem.words(1).join() }
  end

end
