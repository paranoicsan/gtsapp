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

class Branches::FormType < ActiveRecord::Base
  has_many :branches
end
