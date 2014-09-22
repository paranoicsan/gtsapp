FactoryGirl.define do
  factory :street, class: Addresses::Street do
    name { Faker::Address.street_name }
    city_id { FactoryGirl.create(:city).id }
  end

end