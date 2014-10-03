# == Schema Information
#
# Table name: addresses_post_indices
#
#  id         :integer          not null, primary key
#  code       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_addresses_post_indices_on_id  (id)
#

FactoryGirl.define do

  factory :post_index, class: Addresses::PostIndex do
    code 236000
  end

end
