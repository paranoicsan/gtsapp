# Encoding: utf-8
require_dependency 'reports/company_by_street.rb'

class ReportCompanyByStreetXLS < Spreadsheet::Workbook
  include CompanyByStreet

  def to_xls
    # создаём один лист
    @sheet = create_worksheet :name => "Компании по улице"

    @bold = Spreadsheet::Format.new :weight => :bold
    @italic = Spreadsheet::Format.new :italic => true
    @underline = Spreadsheet::Format.new :underline => true

    write_header # пишем заголовок
    write_companies # пишем сами компании

  end

  def write_header
    street = Street.find(street_id)
    @sheet.row(0).push %Q{#{street.name} (#{street.city.name})}
    @sheet.row(1).push %Q{Рубрикатор: #{Rubric.rubricator_name_for(filter_rubricator)}}
    @sheet.row(2).push filter_title
  end

  def write_companies

    cnt = 4 # счётчик рядов

    companies = Company.by_street street_id, filter: filter, rubricator_filter: filter_rubricator
    companies.each do |c|

      # названия компании
      @sheet.row(cnt).set_format(0, @bold)
      @sheet.row(cnt).push c.title

      if c.branches.any?
        @sheet.row(cnt + 1).push "#{c.main_branch.fact_name}, #{c.main_branch.legel_name}"

        cnt = write_addresses c, cnt + 3 # адреса
      end

      cnt = write_persons c, cnt + 1 # персоны
      cnt = write_emails c, cnt + 1 # Почта
      cnt = write_websites c, cnt + 1 # веб-сайты
      cnt = write_rubrics c, cnt + 1 # рубрики
      cnt = write_contracts c, cnt + 1 # активные договора

      cnt += 2
    end
  end

  def write_contracts(company, cnt)
    @sheet.row(cnt).set_format(0, @underline)
    @sheet.row(cnt).push "Договора"
    row_cnt = cnt + 1
    company.contracts.each do |c|
      @sheet.row(row_cnt).push c.info
      row_cnt += 1
    end
    row_cnt
  end

  def write_rubrics(company, cnt)
    @sheet.row(cnt).set_format(0, @underline)
    @sheet.row(cnt).push "Рубрики"
    row_cnt = cnt + 1

    company.rubrics.each do |rub|
      @sheet.row(row_cnt).push rub.name
      row_cnt += 1
    end

    row_cnt + 1
  end

  def write_websites(company, cnt)
    @sheet.row(cnt).set_format(0, @underline)
    @sheet.row(cnt).push "Веб-сайты"
    row_cnt = cnt + 1

    company.branches_sorted.each do |b|
      if b.all_websites_str.length > 0
        @sheet.row(row_cnt).push b.all_websites_str
        row_cnt += 1
      end
    end

    row_cnt
  end

  def write_emails(company, cnt)
    @sheet.row(cnt).set_format(0, @underline)
    @sheet.row(cnt).push "Почта"
    row_cnt = cnt + 1

    company.branches_sorted.each do |b|
      if b.all_emails_str.length > 0
        @sheet.row(row_cnt).push b.all_emails_str
        row_cnt += 1
      end
    end
    row_cnt
  end

  def write_persons(company, cnt)
    @sheet.row(cnt).set_format(0, @underline)
    @sheet.row(cnt).push "Персоны"
    row_cnt = cnt + 1
    company.persons.each do |per|
      @sheet.row(row_cnt).push per.full_info
      row_cnt += 1
    end
    row_cnt
  end

  def write_phones(branch, row_pos)
    branch.phones_by_order.each do |p|
      @sheet.row(row_pos)[1] = %Q{#{p.name_formatted(true)} - #{p.description}}
      row_pos += 1
    end
    row_pos+1
  end

  def write_addresses(company, cnt)
    @sheet.row(cnt).set_format(0, @underline)
    @sheet.row(cnt).push "Адреса"

    row_cnt = cnt + 1

    # пишем филиалы с телефонами
    row_cnt = write_branch company.main_branch, row_cnt
    company.branches_sorted.each do |b|
      unless b.is_main
        row_cnt = write_branch b, row_cnt
        row_cnt += 1
      end
    end

    row_cnt
  end

  ##
  # Пишет информацию по филиалам и их телефонам
  def write_branch(branch, row_pos)
    s = branch.is_main? ? "(*) " : ""
    @sheet.row(row_pos).push "#{s}#{branch.fact_name}"

    row_pos += 1
    @sheet.row(row_pos)[1] = branch.address.full_address unless branch.address.nil?

    row_pos += 2
    write_phones branch, row_pos
  end


end