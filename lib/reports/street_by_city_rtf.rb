# Encoding: utf-8
require_dependency 'reports/street_by_city.rb'

class ReportStreetByCityRTF < RTF::Document
  include ReportStreetByCity

  def get_data
    super
    write_header
    write_streets
    to_rtf
  end

  ##
  # Абстрактный метод для формирования отчёта
  def write_header
    paragraph do |p|
      p.apply(@styles['HEADER']) << City.find(city_id).name
    end
    paragraph.line_break
  end

  ##
  # Абстрактный метод для формирования отчёта
  def write_streets
    paragraph do |p|
      Street.where("city_id = ?", city_id).order("name ASC").each do |street|
      #Street.find_all_by_city_id(city_id).each do |street|
        p << street.name
        p.line_break
      end
    end
  end

  ##
  # Готовим стили
  def prepare_styles
    super
    @styles = {}
    @styles['HEADER'] = RTF::CharacterStyle.new
    @styles['HEADER'].bold = true
    @styles['HEADER'].font_size = 28
  end

end