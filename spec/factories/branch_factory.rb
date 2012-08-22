FactoryGirl.define do

  factory :branch do
    fact_name { Faker::Company.name }
    legel_name { Faker::Company.name }
    company { FactoryGirl.create :company }
  end

end