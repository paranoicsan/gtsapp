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

end
