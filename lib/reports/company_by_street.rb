#Encoding: utf-8
module CompanyByStreet
  # Улица
  attr_accessor :street_id
  # Фитльтр по статусу компаний
  attr_accessor :filter
  # Фильтр по типу рубрикатора
  attr_accessor :filter_rubricator

  ##
  # Готовим текстовое название для выбранного фильтра
  def filter_title
    case @filter
      when :active
        "Активные компании"
      when :archived
        "Архивные компании"
      else
        "Все компании"
    end
  end
  
end