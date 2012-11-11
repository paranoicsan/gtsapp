# Encoding: utf-8
require_dependency 'reports/company_by_rubric.rb'

class ReportCompanyByRubricRTF < RTF::Document
  include CompanyByRubric

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
    companies = get_companies
    companies.each do |c|

      paragraph do |p|
        p.apply(@styles['HEADER']) << c.title
        p.line_break

        if c.branches.any?
          p << "#{c.main_branch.fact_name}, #{c.main_branch.legel_name}"  unless c.main_branch.nil?
          write_addresses c # адреса
        end

      end

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

  def write_phones(branch, par)
    branch.phones_by_order.each do |p|
      par << %Q{#{p.name_formatted(true)} - #{p.description}}
      par.line_break
    end
  end

  def write_addresses(company)
    write_section_header("Адреса")
    write_branch company.main_branch
    company.branches_sorted.each do |b|
      write_branch(b) unless b.is_main?
    end
  end

  def write_header
    paragraph << %Q{Рубрика: #{rubric.name}} unless rubric.nil?
    paragraph.line_break
    paragraph << get_filter_text
  end

  ##
  # Пишет информацию по филиалам и их телефонам
  def write_branch(branch)
    unless branch.nil?
      s = branch.is_main? ? "(*)" : ""
      paragraph do |p|
        p << "#{s} #{branch.fact_name}"
        p.line_break
      end
      ps = RTF::ParagraphStyle.new
      ps.left_indent = 200
      paragraph(ps) do |p|
        unless branch.address.nil?
          p << branch.address.full_address
          2.times {p.line_break}
        end
        write_phones branch, p
      end
    end
  end

end