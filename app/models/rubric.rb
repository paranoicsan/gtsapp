class Rubric < ActiveRecord::Base
  has_many :company_rubric
  has_many :keywords
  has_many :products
  belongs_to :rubric_keyword
  validates_presence_of :name
  scope :social, where(:social => true)
  scope :commercial, where(:social => false)

  ##
  # Возвращает определённый набор рубрик в зависимости
  # от рубрикатора
  # @param [Integer] Тип рубрикатора
  # @return [Array] Массив рубрик
  def self.by_rubricator(rubricator)
    case rubricator
      # Социальный
      when 1
        Rubric.social.order('name')
      # коммерческий
      when 2
        Rubric.commercial.order('name')
      else
        Rubric.order('name').all
    end
  end

end