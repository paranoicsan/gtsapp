class Phone < ActiveRecord::Base
  belongs_to :branch
  validates_presence_of :name

  ##
  # Возвращает отформатированный номер телефона
  # Если номер - мобильный, то вначале добавляется префикс сотового оператора
  def name_formatted
    mobile? ? "(#{mobile_refix}) #{name}" : name
  end
end
