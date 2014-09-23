FactoryGirl.define do

  factory :website, class: Branches::Website do
    name { Faker::Internet.url }
  end

end