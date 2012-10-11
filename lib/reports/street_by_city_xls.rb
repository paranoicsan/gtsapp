# Encoding: utf-8
require_dependency 'reports/street_by_city.rb'

class ReportStreetByCityXLS < Spreadsheet::Workbook
  include ReportStreetByCity

  def get_data
    super
    write_header
    write_streets

  end

  ##
  def write_header
    @sheet.row(0).set_format(0, @bold)
    @sheet.row(0).push City.find(city_id).name
  end

  ##
  def write_streets
    row = 2
    Street.where("city_id = ?", city_id).order("name ASC").each do |street|
      @sheet.row(row).push street.name
      row += 1
    end
  end

  ##
  # Готовим стили
  def prepare_styles
    super
    # создаём один лист
    @sheet = create_worksheet :name => "Компании по улице"

    @bold = Spreadsheet::Format.new :weight => :bold
    @italic = Spreadsheet::Format.new :italic => true
    @underline = Spreadsheet::Format.new :underline => true

  end

end