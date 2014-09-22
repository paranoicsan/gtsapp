FactoryGirl.define do
  factory :city, class: Addresses::City do
    name { Faker::Address.city }
    phone_code 4012
  end

end