# == Schema Information
#
# Table name: branches_websites
#
#  id   :integer          not null, primary key
#  name :string(255)
#

FactoryGirl.define do

  factory :website, class: Branches::Website do
    name { Faker::Internet.url }
  end

end
