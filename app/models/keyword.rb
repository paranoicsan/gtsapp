class Keyword < ActiveRecord::Base
  belongs_to :rubric
  belongs_to :rubric_keyword
  validates_presence_of :name
end