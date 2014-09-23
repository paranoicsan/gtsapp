FactoryGirl.define do

  factory :email, class: Branches::Email do
    name { Faker::Internet.email }
  end

end