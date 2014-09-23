FactoryGirl.define do

  factory :form_type, class: Branches::FormType do
    name { Faker::Lorem.words(1).join }
  end

end