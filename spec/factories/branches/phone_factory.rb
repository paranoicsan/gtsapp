FactoryGirl.define do

  factory :phone, class: Branches::Phone do
    name { Faker::PhoneNumber.phone_number }
    mobile false
    contact false
    description { Faker::Lorem.words(1).join }
    director false
    fax false
    mobile_refix 921
    branch

    before(:create) do |phone|
      phone.order_num = phone.branch.next_phone_order_index
    end
  end

end