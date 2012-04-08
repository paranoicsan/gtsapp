# encoding: utf-8
class Company < ActiveRecord::Base
  belongs_to :company_status
  validates_presence_of :title

  # Возвращает истину, если компания владеет только социальным рубрикатором
  def social_rubricator?
    self.rubricator == 1
  end

  # Возвращает истину, если компания владеет только коммерческим рубрикатором
  def commercial_rubricator?
    self.rubricator == 2
  end

  # Возвращает истину, если компания входит во все рубрикаторы
  def full_rubricator?
    self.rubricator == 3
  end


  # Выводит текстовое обозначение рубриктора для компании
  # @return [string] Текстовое значение рубрикатора
  def rubricator_name
    case self.rubricator
      when 1 then "Социальный"
      when 2 then "Коммерческий"
      when 3 then "Полный"
      else
        "Не указан"
    end
  end

end
