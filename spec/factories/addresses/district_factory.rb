FactoryGirl.define do

  factory :district, class: Addresses::District do
    name { ['район', Faker::Name.name].join(' ') }
  end

end