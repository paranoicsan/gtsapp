# Encoding: utf-8
class ReportCompanyByStreetPDF < Prawn::Document

  # Улица
  attr_accessor :street_id
  # Фитльтр по статусу компаний
  attr_accessor :filter
  # Фильтр по типу рубрикатора
  attr_accessor :filter_rubricator

  def to_pdf
    # привязываем шрифты
    s = "#{Rails.root}/lib/fonts"
    font_families.update(
        "Verdana" => {
            :bold => "#{s}/verdanab.ttf",
            :italic => "#{s}/verdanai.ttf",
            :normal  => "#{s}/verdana.ttf" })

    write_header # пишем заголовок

    font "Verdana", :size => 10

    text "Address: аываыаыва"
    text "Email: ваффафафафаыаыв"

    render
  end

  ##
  # Формирует строку c адресным фильтром
  def address_summary
    street = Street.find(street_id)
    %Q{#{street.name} (#{street.city.name})}
  end

  def write_header
    font "Verdana", :size => 14
    text address_summary
    text %Q{Рубрикатор: #{Rubric.rubricator_name_for(filter_rubricator)}}
  end

end