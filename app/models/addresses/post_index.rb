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

class Addresses::PostIndex < ActiveRecord::Base
  has_many :street_indexes
  has_many :addresses

  attr_accessible :old_id
end
