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

    @bold = Spreadsheet::Format.new :weight => :bold
    @italic = Spreadsheet::Format.new :italic => true

    write_header # пишем заголовок
    write_companies # пишем сами компании

  end

  def write_header
    street = Street.find(street_id)
    @sheet.row(0).push %Q{#{street.name} (#{street.city.name})}
    @sheet.row(1).push %Q{Рубрикатор: #{Rubric.rubricator_name_for(filter_rubricator)}}
  end

  def write_companies

    cnt = 3 # счётчик рядов

    companies = Company.by_street street_id, filter: filter, rubricator_filter: filter_rubricator
    companies.each do |c|

      # названия компании
      @sheet.row(cnt).set_format(0, @bold)
      @sheet.row(cnt).push c.title
      @sheet.row(cnt + 1).push "#{c.main_branch.fact_name}, #{c.main_branch.legel_name}"

      cnt = write_addresses c, cnt + 3 # адреса
      cnt = write_phones c, cnt + 2 # телефоны
      #write_persons c # персоны
      #write_emails c # Почта
      #write_websites c # веб-сайты
      #write_rubrics c # рубрики
      #write_contracts c # активные договора

      cnt += 2
    end
  end

  #def write_contracts(company)
  #  font "Verdana", size: 10, style: :italic
  #  text "Активные договора"
  #  move_down 5
  #  font "Verdana", size: 10
  #  company.contracts.each do |c|
  #    if c.active?
  #      text c.info
  #    end
  #  end
  #  move_down 10
  #end
  #
  #def write_rubrics(company)
  #  font "Verdana", size: 10, style: :italic
  #  text "Рубрики"
  #  move_down 5
  #  font "Verdana", size: 10
  #
  #  company.rubrics.each do |rub|
  #    text rub.name
  #  end
  #
  #  move_down 10
  #end
  #
  #def write_websites(company)
  #  font "Verdana", size: 10, style: :italic
  #  text "Веб-сайты"
  #  move_down 5
  #  font "Verdana", size: 10
  #
  #  company.branches_sorted.each do |b|
  #    if b.all_websites_str.length > 0
  #      text b.all_websites_str
  #    end
  #  end
  #
  #  move_down 10
  #end
  #
  #def write_emails(company)
  #  font "Verdana", size: 10, style: :italic
  #  text "Почта"
  #  move_down 5
  #  font "Verdana", size: 10
  #
  #  company.branches_sorted.each do |b|
  #    if b.all_emails_str.length > 0
  #      text b.all_emails_str
  #    end
  #  end
  #  move_down 10
  #end
  #
  #def write_persons(company)
  #  font "Verdana", size: 10, style: :italic
  #  text "Персоны"
  #  move_down 5
  #  font "Verdana", size: 10
  #
  #  company.persons.each do |per|
  #    text per.full_info
  #  end
  #
  #  move_down 10
  #end

  def write_phones(company, cnt)
    @sheet.row(cnt).set_format(0, @italic)
    @sheet.row(cnt).push "Телефоны"

    row_cnt = cnt + 1

    company.branches_sorted.each do |b|
      b.phones_by_order.each do |p|
        @sheet.row(row_cnt).push %Q{#{p.name_formatted} - #{p.description}}
        row_cnt += 1
      end
    end
    row_cnt
  end

  def write_addresses(company, cnt)
    @sheet.row(cnt).set_format(0, @italic)
    @sheet.row(cnt).push "Адреса"
    @sheet.row(cnt+1).push "(*) #{company.main_branch.fact_name}, #{company.main_branch.legel_name}, #{company.main_branch.address.full_address}"

    row_cnt = cnt + 1

    company.branches_sorted.each do |b|
      unless b.is_main
        @sheet.row(row_cnt + 1).push "#{b.fact_name}, #{b.legel_name}, #{b.address.full_address}"
        row_cnt += 1
      end
    end

    row_cnt
  end

end