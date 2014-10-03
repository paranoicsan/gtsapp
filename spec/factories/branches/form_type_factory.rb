# == Schema Information
#
# Table name: branches_form_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_branches_form_types_on_id  (id)
#

FactoryGirl.define do

  factory :form_type, class: Branches::FormType do
    name { Faker::Lorem.words(1).join }
  end

end
