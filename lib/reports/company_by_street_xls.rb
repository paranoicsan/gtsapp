# Encoding: utf-8
class ReportCompanyByStreetXLS < Spreadsheet::Workbook

  # Улица
  attr_accessor :street_id
  # Фитльтр по статусу компаний
  attr_accessor :filter
  # Фильтр по типу рубрикатора
  attr_accessor :filter_rubricator

  def to_xls
    # создаём один лист
    @sheet = create_worksheet :name => "Компании по улице"

    write_header # пишем заголовок
    #write_companies # пишем сами компании

  end

  def write_header
    street = Street.find(street_id)
    @sheet.row(0).push %Q{#{street.name} (#{street.city.name})}
    @sheet.row(1).push %Q{Рубрикатор: #{Rubric.rubricator_name_for(filter_rubricator)}}
  end

end