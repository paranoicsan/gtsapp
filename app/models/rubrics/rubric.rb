# Encoding: utf-8
class Rubrics::Rubric < ActiveRecord::Base

  RUBRICATOR_TYPE = %w(Социальный Коммерческий Полный)
  RUBRICATOR_SOC = 0
  RUBRICATOR_COM = 1
  RUBRICATOR_FULL = 2

  # noinspection RailsParamDefResolve
  has_many :products, class_name: 'Products::Product', dependent: :restrict
  has_and_belongs_to_many :companies, class_name: 'Companies::Company', join_table: 'companies_rubrics_join'
  has_and_belongs_to_many :keywords, class_name: 'Rubrics::Keyword',
                          join_table: 'rubrics_keywords_join'

  validates_presence_of :name, message: 'Укажите название рубрики.'
  validates_uniqueness_of :name, message: 'Такая рубрика уже существует.',
                          case_sensitive: false

  scope :social, ->{ where(social: true) }
  scope :commercial, ->{ where(social: false) }

  ##
  # Возвращает определённый набор рубрик в зависимости
  # от рубрикатора
  # @param [Integer] Тип рубрикатора
  # @return [Array] Массив рубрик
  def self.by_rubricator(rubricator)
    case rubricator
      # Социальный
      when 1
        social.order('name')
      # коммерческий
      when 2
        commercial.order('name')
      else
        order('name').all
    end
  end

  ##
  # Возвращает буквенное обозначение рубрикатора
  # @param [Integer] Тип рубрикатора
  #
  # TODO: Переписать на отдачу по прямому индексу вместе с задачей
  # по миграции существующих данных
  #
  def self.rubricator_name_for(type)
    return RUBRICATOR_TYPE.try :[], type-1
  end

end