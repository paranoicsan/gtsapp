# == Schema Information
#
# Table name: addresses_street_indices
#
#  id            :integer          not null, primary key
#  street_id     :integer
#  post_index_id :integer
#  comments      :string(255)
#
# Indexes
#
#  index_addresses_street_indices_on_id  (id)
#

class Addresses::StreetIndex < ActiveRecord::Base
  belongs_to :street
  belongs_to :post_index
end
