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
    write_companies # пишем сами компании

    string = "<page> из <total>"
    options = {
        :at => [bounds.right - 150, 0],
        :width => 150,
        :align => :right
    }
    number_pages string, options

    render
  end

  def write_companies
    companies = Company.by_street street_id, filter: filter, rubricator_filter: filter_rubricator
    companies.each do |c|

      # названия компании
      font "Verdana", size: 12, style: :bold
      text c.title
      font "Verdana", size: 10
      text "#{c.main_branch.fact_name}, #{c.main_branch.legel_name}"
      move_down 5

      write_addresses c # адреса
      write_phones c # телефоны
      write_persons c # персоны
      write_emails c # Почта
      write_websites c # веб-сайты
      write_rubrics c # рубрики
      write_contracts c # активные договора
    end
  end

  def write_contracts(company)
    font "Verdana", size: 10, style: :italic
    text "Активные договора"
    move_down 5
    font "Verdana", size: 10
    company.contracts.each do |c|
      if c.active?
         text c.info
      end
    end
    move_down 10
  end

  def write_rubrics(company)
    font "Verdana", size: 10, style: :italic
    text "Рубрики"
    move_down 5
    font "Verdana", size: 10

    company.rubrics.each do |rub|
      text rub.name
    end

    move_down 10
  end

  def write_websites(company)
    font "Verdana", size: 10, style: :italic
    text "Веб-сайты"
    move_down 5
    font "Verdana", size: 10

    company.branches_sorted.each do |b|
      if b.all_websites_str.length > 0
         text b.all_websites_str
      end
    end

    move_down 10
  end

  def write_emails(company)
    font "Verdana", size: 10, style: :italic
    text "Почта"
    move_down 5
    font "Verdana", size: 10

    company.branches_sorted.each do |b|
      if b.all_emails_str.length > 0
       text b.all_emails_str
      end
    end
    move_down 10
  end

  def write_persons(company)
    font "Verdana", size: 10, style: :italic
    text "Персоны"
    move_down 5
    font "Verdana", size: 10

    company.persons.each do |per|
      text per.full_info
    end

    move_down 10
  end

  def write_phones(company)
    font "Verdana", size: 10, style: :italic
    text "Телефоны"
    move_down 5
    font "Verdana", size: 10
    company.branches_sorted.each do |b|
      b.phones_by_order.each do |p|
        text %Q{#{p.name_formatted} - #{p.description}}
      end
    end
    move_down 10
  end

  def write_addresses(company)
    font "Verdana", size: 10, style: :italic
    text "Адреса"
    move_down 5
    font "Verdana", size: 10
    text "(*) #{company.main_branch.fact_name}, #{company.main_branch.legel_name}, #{company.main_branch.address.full_address}"
    company.branches_sorted.each do |b|
      unless b.is_main
        text "#{b.fact_name}, #{b.legel_name}, #{b.address.full_address}"
      end
    end
    move_down 10
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
    move_down 20
  end

end