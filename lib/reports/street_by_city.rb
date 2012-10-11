# Encoding: utf-8
module ReportStreetByCity
  # Ключ города
  attr_accessor :city_id

  ##
  # Абстрактный метод для формирования отчёта
  def get_data
    prepare_styles # подготовливаем стили
  end

  ##
  # Абстрактный метод для формирования отчёта
  def write_header
  end

  ##
  # Абстрактный метод для формирования отчёта
  def write_streets
  end

  ##
  # Готовит стили
  def prepare_styles
  end
end
