# == Schema Information
#
# Table name: branches_form_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Branches::FormType < ActiveRecord::Base
  has_many :branches
end
