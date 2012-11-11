# Encoding: utf-8
require_dependency 'reports/company_by_rubric'

class ReportCompanyByRubricPDF < Prawn::Document
  include CompanyByRubric

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
    #companies = Company.by_street street_id, filter: filter, rubricator_filter: filter_rubricator
    companies = get_companies
    companies.each do |c|

      # названия компании
      font "Verdana", size: 12, style: :bold
      text c.title

      if c.branches.any?
        font "Verdana", size: 10
        text "#{c.main_branch.fact_name}, #{c.main_branch.legel_name}" unless c.main_branch.nil?
        move_down 10

        write_addresses c # адреса
      end
      move_down 10

      font "Verdana", size: 10
      write_persons c # персоны
      write_emails c # Почта
      write_websites c # веб-сайты
      write_rubrics c # рубрики
      write_contracts c # активные договора

      move_down 20
    end
  end

  def write_contracts(company)
    text "<u>Договоры</u>", inline_format: true
    move_down 5
    font "Verdana", size: 10
    company.contracts.each {|c| text c.info }
    move_down 10
  end

  def write_rubrics(company)
    text "<u>Рубрики</u>", inline_format: true
    move_down 5
    font "Verdana", size: 10

    company.rubrics.each { |rub| text rub.name }

    move_down 10
  end

  def write_websites(company)
    text "<u>Веб-сайты</u>", inline_format: true
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
    text "<u>Почта</u>", inline_format: true
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
    text "<u>Персоны</u>", inline_format: true
    move_down 5
    font "Verdana", size: 10

    company.persons.each do |per|
      text per.full_info
    end

    move_down 10
  end

  def write_phones(branch)
    branch.phones_by_order.each do |p|
      text %Q{#{p.name_formatted(true)} - #{p.description}}
    end
    move_down 10
  end

  def write_addresses(company)
    text "<u>Адреса</u>", inline_format: true
    move_down 5
    write_branch(company.main_branch) # головной филиал
    company.branches_sorted.each { |b| write_branch b unless b.is_main? }
  end

  def write_header
    font "Verdana", :size => 14
    text %Q{Рубрика: #{rubric.name}} unless rubric.nil?
    move_down 10
    font "Verdana", :size => 12
    text get_filter_text
    move_down 20
  end

  ##
  # Пишет информацию по филиалам и их телефонам
  def write_branch(branch)
    unless branch.nil?
      s = branch.is_main? ? "(*)" : ""
      text "#{s} #{branch.fact_name}"
      move_down 5
      indent(20) do
        unless branch.address.nil?
          text branch.address.full_address
          move_down 5
        end
        write_phones branch
      end
    end
  end

end