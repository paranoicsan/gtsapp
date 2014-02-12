require 'faker'

FactoryGirl.define do
  factory :street do
    name { Faker::Address.street_name }
    city { FactoryGirl.create :city }
  end

end