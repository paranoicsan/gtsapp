# == Schema Information
#
# Table name: addresses_addresses
#
#  id            :integer          not null, primary key
#  house         :string(255)
#  entrance      :string(255)
#  case          :string(255)
#  stage         :string(255)
#  office        :string(255)
#  cabinet       :string(255)
#  other         :string(255)
#  pavilion      :string(255)
#  litera        :string(255)
#  district_id   :integer
#  city_id       :integer
#  street_id     :integer
#  post_index_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  branch_id     :integer
#

FactoryGirl.define do

  factory :address, class: Addresses::Address do
    cabinet 2
    entrance 34
    house 456
    litera 'A'
    office 345
    other { Faker::Lorem.words.join(' ') }
    pavilion 44
    stage 8

    association :branch, factory: :branch
    city
    street

    after(:create) do |a|
      a.case = 1
    end

  end

end
