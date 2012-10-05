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
      write_persons c # персоны
      write_emails c # Почта
      write_websites c # веб-сайты
      write_rubrics c # рубрики
      write_contracts c # активные договора

      2.times { paragraph.line_break }
    end
  end

  def write_contracts(company)
    write_section_header("Активные договора")
    paragraph do |p|
      company.contracts.each do |c|
        if c.active?
          p << c.info
          p.line_break
        end
      end
    end
  end

  ##
  # Пишет название секции отчёта
  # @param [String] title Название секции
  def write_section_header(title)
    paragraph.apply(@styles['SectionHeader']) do |p|
      p.line_break
      p << title
    end
  end

  def write_rubrics(company)
    write_section_header("Рубрики")
    paragraph do |p|
      company.rubrics.each do |rub|
        p << rub.name
        p.line_break
      end
    end
  end

  def write_websites(company)
    write_section_header("Веб-сайты")
    paragraph do |p|
      company.branches_sorted.each do |b|
        if b.all_websites_str.length > 0
          p << b.all_websites_str
          p.line_break
        end
      end
    end
  end

  def write_emails(company)
    write_section_header("Почта")
    paragraph do |p|
      company.branches_sorted.each do |b|
        if b.all_emails_str.length > 0
          p << b.all_emails_str
          p.line_break
        end
      end
    end
  end

  def write_persons(company)
    write_section_header("Персоны")
    paragraph do |par|
      company.persons.each do |per|
        par << per.full_info
        par.line_break
      end
    end
  end

  def write_phones(company)
    write_section_header("Телефоны")
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
    write_section_header("Адреса")
    paragraph << "(*) #{company.main_branch.fact_name}, #{company.main_branch.legel_name}, #{company.main_branch.address.full_address}"
    paragraph do |p|
      company.branches_sorted.each do |b|
        unless b.is_main
          s = "#{b.fact_name}, #{b.legel_name}"
          s = "#{s}, #{b.address.full_address}" unless b.address.nil?
          p << s
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