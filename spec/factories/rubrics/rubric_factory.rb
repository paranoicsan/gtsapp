# == Schema Information
#
# Table name: rubrics_rubrics
#
#  id     :integer          not null, primary key
#  name   :string(255)
#  social :boolean
#

FactoryGirl.define do

  factory :rubric, class: Rubrics::Rubric do
    name { Faker::Lorem.words.join }
    social true

    factory :rubric_comercial do
      social false
    end

  end

end
