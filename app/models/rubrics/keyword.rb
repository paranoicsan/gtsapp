# == Schema Information
#
# Table name: rubrics_keywords
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_rubrics_keywords_on_id  (id)
#

class Rubrics::Keyword < ActiveRecord::Base
  has_and_belongs_to_many :rubrics
  validates_presence_of :name
end
