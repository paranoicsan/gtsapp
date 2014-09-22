# Encoding: utf-8
class Rubric < ActiveRecord::Base


  # noinspection RailsParamDefResolve
  has_many :products, dependent: :restrict
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :keywords

  validates_presence_of :name, message: 'Укажите название рубрики.'
  validates_uniqueness_of :name, message: 'Такая рубрика уже существует.',
                          case_sensitive: false

  scope :social, where(social: true)
  scope :commercial, where(social: false)

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

  ##
  # Возвращает буквенное обозначение рубрикатора
  # @param [Integer] Тип рубрикатора
  def self.rubricator_name_for(type)
    case type
      when 1
        'Социальный'
      when 2
        'Коммерческий'
      when 3
        'Полный'
      else
        raise 'Unknown rubricator type'
    end
  end

end