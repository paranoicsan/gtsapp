class CompanyRubric < ActiveRecord::Base
  belongs_to :company
  belongs_to :rubric
end
