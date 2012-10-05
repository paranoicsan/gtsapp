# Encoding: utf-8
class ReportCompanyByStreetRTF < RTF::Document

  # Улица
  attr_accessor :street_id
  # Фитльтр по статусу компаний
  attr_accessor :filter
  # Фильтр по типу рубрикатора
  attr_accessor :filter_rubricator

  def to_rtf
    @styles = {}
    @styles['HEADER'] = RTF::CharacterStyle.new
    @styles['HEADER'].bold = true

    @styles['SectionHeader'] = RTF::CharacterStyle.new
    @styles['SectionHeader'].italic = true
    @styles['SectionHeader'].underline = true
    @styles['NORMAL'] = RTF::CharacterStyle.new
    @styles['NORMAL'].italic = false
    @styles['NORMAL'].bold = false

    write_header # пишем заголовок
    write_companies # пишем сами компании
    super
  end

  def write_companies
    companies = Company.by_street street_id, filter: filter, rubricator_filter: filter_rubricator
    companies.each do |c|

      # названия компании
      paragraph do |p|
        p.apply(@styles['HEADER']) << c.title
        p.line_break
        p << "#{c.main_branch.fact_name}, #{c.main_branch.legel_name}"
      end

      write_addresses c # адреса
      write_phones c # телефоны
      #write_persons c # персоны
      #write_emails c # Почта
      #write_websites c # веб-сайты
      #write_rubrics c # рубрики
      #write_contracts c # активные договора
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
    paragraph.apply(@styles['SectionHeader']) do |p|
      p.line_break
      p << "Телефоны"
    end
    paragraph do |par|
      company.branches_sorted.each do |b|
        b.phones_by_order.each do |p|
          par << %Q{#{p.name_formatted} - #{p.description}}
          par.line_break
        end
      end
    end
  end

  def write_addresses(company)
    paragraph.apply(@styles['SectionHeader']) do |p|
      p.line_break
      p << "Адреса"
    end
    paragraph << "(*) #{company.main_branch.fact_name}, #{company.main_branch.legel_name}, #{company.main_branch.address.full_address}"
    paragraph do |p|
      company.branches_sorted.each do |b|
        unless b.is_main
          p << "#{b.fact_name}, #{b.legel_name}, #{b.address.full_address}"
          p.line_break
        end
      end
    end
  end

  ##
  # Формирует строку c адресным фильтром
  def address_summary
    street = Street.find(street_id)
    %Q{#{street.name} (#{street.city.name})}
  end

  def write_header
    paragraph do |p|
      p.apply(@styles['HEADER']) << address_summary
    end
    paragraph << %Q{Рубрикатор: #{Rubric.rubricator_name_for(filter_rubricator)}}
    paragraph.line_break
  end

end