# Encoding: utf-8
class Rubric < ActiveRecord::Base
  #noinspection RailsParamDefResolve
  has_many :company_rubric, :dependent => :restrict
  #noinspection RailsParamDefResolve
  has_many :keywords, :dependent => :restrict
  #noinspection RailsParamDefResolve
  has_many :products, :dependent => :restrict
  belongs_to :rubric_keyword
  validates_presence_of :name, :message => "Укажите название рубрики."
  validates_uniqueness_of :name, :message => "Такая рубрика уже существует.", :case_sensitive => false

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