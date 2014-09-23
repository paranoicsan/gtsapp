FactoryGirl.define do

  factory :branch, class: Branches::Branch do
    fact_name { Faker::Company.name }
    legel_name { Faker::Company.name }
    company
  end

end