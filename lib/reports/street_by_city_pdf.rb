# Encoding: utf-8
require_dependency 'reports/street_by_city.rb'

class ReportStreetByCityPDF < Prawn::Document
  include ReportStreetByCity

  def get_data
    super
    write_header
    write_streets
    string = "<page> из <total>"
    options = {
        :at => [bounds.right - 150, 0],
        :width => 150,
        :align => :right
    }
    number_pages string, options
    render
  end

  ##
  def write_header
    font "Verdana", :size => 14
    text City.find(city_id).name
    move_down 20
  end

  ##
  def write_streets
    font "Verdana", size: 10
    Street.where("city_id = ?", city_id).order("name ASC").each do |street|
      text street.name
    end
  end

  ##
  # Готовим стили
  def prepare_styles
    super
    # привязываем шрифты
    s = "#{Rails.root}/lib/fonts"
    font_families.update(
        "Verdana" => {
            :bold => "#{s}/verdanab.ttf",
            :italic => "#{s}/verdanai.ttf",
            :normal  => "#{s}/verdana.ttf" })


  end

end