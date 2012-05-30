class Rubric < ActiveRecord::Base
  has_many :company_rubric
  has_many :keywords
  belongs_to :rubric_keyword
  validates_presence_of :name

  def self.by_rubricator(rubricator)
    case rubricator
      # Социальный
      when 1
        Rubric.find_all_by_social true
      # коммерческий
      when 2
        Rubric.find_all_by_social false
      else
        Rubric.all
    end
  end

end