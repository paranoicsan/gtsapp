class RubricKeyword < ActiveRecord::Base
  has_many :rubrics
  has_many :keywords
  validates_presence_of :rubric_id, :keyword_id
end
