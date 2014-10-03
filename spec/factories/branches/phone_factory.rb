# == Schema Information
#
# Table name: branches_phones
#
#  id           :integer          not null, primary key
#  mobile_refix :string(255)
#  publishable  :boolean
#  fax          :boolean
#  director     :boolean
#  mobile       :boolean
#  description  :text
#  name         :string(255)
#  contact      :integer
#  order_num    :integer
#  branch_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_branches_phones_on_id  (id)
#

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
