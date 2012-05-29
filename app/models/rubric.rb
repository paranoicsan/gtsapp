class Rubric < ActiveRecord::Base
  has_many :company_rubric
  has_many :keywords
  belongs_to :rubric_keyword
  validates_presence_of :name
end