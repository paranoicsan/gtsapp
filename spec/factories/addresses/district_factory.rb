# == Schema Information
#
# Table name: addresses_districts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_addresses_districts_on_id  (id)
#

FactoryGirl.define do

  factory :district, class: Addresses::District do
    name { ['район', Faker::Name.name].join(' ') }
  end

end
