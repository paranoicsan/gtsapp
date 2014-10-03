# == Schema Information
#
# Table name: branches_branches
#
#  id           :integer          not null, primary key
#  form_type_id :integer
#  fact_name    :string(255)
#  legel_name   :string(255)
#  company_id   :integer
#  comments     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_main      :boolean
#
# Indexes
#
#  index_branches_branches_on_id  (id)
#

FactoryGirl.define do

  factory :branch, class: Branches::Branch do
    fact_name { Faker::Company.name }
    legel_name { Faker::Company.name }
    company
  end

end
