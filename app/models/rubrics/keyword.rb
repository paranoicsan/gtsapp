class Rubrics::Keyword < ActiveRecord::Base
  has_and_belongs_to_many :rubrics
  validates_presence_of :name
end
