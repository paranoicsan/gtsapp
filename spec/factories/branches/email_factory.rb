# == Schema Information
#
# Table name: branches_emails
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  branch_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_branches_emails_on_id  (id)
#

FactoryGirl.define do

  factory :email, class: Branches::Email do
    name { Faker::Internet.email }
  end

end
