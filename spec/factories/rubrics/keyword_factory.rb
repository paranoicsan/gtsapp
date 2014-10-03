# == Schema Information
#
# Table name: rubrics_keywords
#
#  id   :integer          not null, primary key
#  name :string(255)
#

FactoryGirl.define do

  factory :keyword, class: Rubrics::Keyword do
    name { Faker::Lorem.words(1).join }
  end

end
