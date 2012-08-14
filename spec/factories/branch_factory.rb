FactoryGirl.define do

  factory :branch do
    fact_name { Faker::Company.name }
    legel_name { Faker::Company.name }
  end

end