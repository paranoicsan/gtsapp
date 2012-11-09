# Encoding: utf-8
Then /^Я могу попасть на страницу формирования отчёта по агенту$/ do
  page.should have_content("По агенту")
  find("a[href='#{report_by_agent_path}'][text()='Показать']").click
  current_path.should eq(report_by_agent_path)
end
When /^Я заполняю параметры отчёта$/ do
  select @agent.username, from: 'report_agent'
  step %Q{Кнопка "do_report_by_agent" - "активна"}
  click_button("Показать")
end
Then /^Я вижу список операций пользователя$/ do
  el_id = "report_results_table"

  # составляем ряды для таблицы
  rows = ""
  CompanyHistory.all.each do |c|
    rows = "#{rows}\n|#{c.company.title}|#{c.operation}|#{c.updated_at.strftime("%d.%m.%Y %H:%M")}|"
  end
  steps %Q{
    Then Я вижу таблицу "#{el_id}" с компаниями
      | title | operation | updated_at |
      #{rows}
  }

end
Then /^Я (|не) могу сформировать отчёт по агенту$/ do |negate|
  s = negate.eql?("не") ? "не активна" : "активна"
  step %Q{Кнопка "do_report_by_agent" - "#{s}"}
end
When /^Я нахожусь на странице отчётов по агенту$/ do
  create_agents # создаём набор агентов
  create_history @agent # создаём операции для указанного агента
  visit report_by_agent_path
end
Then /^Я могу попасть на страницу формирования отчёта компании по улице$/ do
  page.should have_content("Компании по улицам")
  find("a[href='#{report_company_by_street_path}'][text()='Показать']").click
  current_path.should eq(report_company_by_street_path)
end
When /^Я нахожусь на странице отчётов компаний по улице$/ do
  create_company_statuses
  @company = create_company true
  @company.update_attribute "rubricator", 3 # ставим ей полный рубрикатор
  city = FactoryGirl.create :city
  street = FactoryGirl.create :street, city_id: city.id
  3.times do
    branch = FactoryGirl.create :branch, company_id: @company.id
    # персоны
    2.times { FactoryGirl.create :phone, branch_id: branch.id, order_num: 1 }
    # почта
    3.times { FactoryGirl.create :email, branch_id: branch.id }
    # сайты
    3.times { branch.websites <<  FactoryGirl.create(:website) }

    @address = FactoryGirl.create :address, branch_id: branch.id, street_id: street.id, city_id: city.id
  end

  # создаём ещё одну компанию по этому адресу, но эта компания будет неактивна
  lambda {
      company = FactoryGirl.create :company_suspended
      branch = FactoryGirl.create :branch, company_id: company.id
      FactoryGirl.create :address, branch_id: branch.id, street_id: street.id, city_id: city.id
  }

  # создаём еще одну компанию с другими рубрикаторами
  2.times do |i|
    company = FactoryGirl.create :company, rubricator: i+1
    branch = FactoryGirl.create :branch, company_id: company.id
    FactoryGirl.create :address, branch_id: branch.id, street_id: street.id, city_id: city.id
  end

  #персоны
  3.times { FactoryGirl.create :person, company_id: @company.id }

  # договора
  2.times { FactoryGirl.create :contract_active, company_id: @company.id }

  visit report_company_by_street_path
end
When /^Я уже ввёл населенный пункт$/ do
  step %Q{Я могу выбрать населённый пункт автозаполнением "address_city"}
end
Then /^Я (|не) могу сформировать отчёт компаний по улице$/ do |negate|
  s = negate.eql?("не") ? "не активна" : "активна"
  step %Q{Кнопка "do_report_company_by_street" - "#{s}"}
end
When /^Я заполняю параметры отчёта компании по улице$/ do
  steps %Q{
    When Я могу выбрать населённый пункт автозаполнением "address_city"
    Then Я могу выбрать улицу с автозаполнением "address_street"
    And Кнопка "do_report_company_by_street" - "активна"
  }
  click_button("Показать")
end
#Then /^Я вижу список (активных|всех) компаний по выбранной улице$/ do |filter|
#  el_id = "report_results_table"
#
#  # составляем ряды для таблицы
#  rows = ""
#  cs = filter.eql?("активных") ? Company.where("company_status_id = ?", CompanyStatus.active.id) : Company.all
#  cs.each do |c|
#    rows = "#{rows}\n|#{c.title}\\n#{@company.main_branch.fact_name}, #{@company.main_branch.legel_name}|"
#  end
#  steps %Q{
#    Then Я вижу таблицу "#{el_id}" с компаниями
#      | title |
#      #{rows}
#  }
#end
When /^Я вижу список филиалов для каждой компании$/ do
  # проверка головного филиала
  branch = @company.main_branch
  s = "#{branch.fact_name}"
  page.should have_content(s)

  # проверка остальных филиалов
  @company.branches_sorted.each do |b|
    unless b.is_main
      s = "#{b.fact_name}"
      page.should have_content(s)
    end
  end
end
When /^Я вижу список телефонов для каждой компании$/ do
  @company.branches_sorted.each do |b|
    b.phones_by_order.each do |p|
      s = %Q{#{p.name_formatted(true)} - #{p.description}}
      page.should have_content(s)
    end
  end
end
When /^Я вижу список персон для каждой компании$/ do
  @company.persons.each do |p|
    page.should have_content(p.full_info)
  end
end
When /^Я вижу электронную почту для каждой компании$/ do
  @company.branches_sorted.each do |b|
    page.should have_content(b.all_emails_str)
  end
end
When /^Я вижу веб-сайты для каждой компании$/ do
  @company.branches_sorted.each do |b|
    page.should have_content(b.all_websites_str)
  end
end
When /^Я вижу все рубрики для каждой компании$/ do
  s = ""
  @company.rubrics.each do |rub|
    s = %Q{#{s}  #{rub.name}}
  end
  page.should have_content(s.gsub(/,$/, ''))
end
When /^Я вижу информацию о договоре для каждой компании$/ do
  @company.contracts.each do |c|
    if c.active?
      page.should have_content(c.info)
    end
  end
end
When /^Я заполняю параметры отчёта компании по улице для поиска всех компаний$/ do
  choose("filter_all")
  step %Q{Я заполняю параметры отчёта компании по улице с выбором рубрикатора "полный"}
end
When /^Я заполняю параметры отчёта компании по улице с выбором рубрикатора "([^"]*)"$/ do |arg|
  el_id = "rubricator_filter_"
  case arg
    when "полный"
      el_id += "3"
      @rub_filter = 3
    when "социальный"
      el_id += "1"
      @rub_filter = 1
    when "коммерческий"
      el_id += "2"
      @rub_filter = 2
    else
      raise "Unknown rubricator type"
  end
  choose(el_id)
  step %Q{Я заполняю параметры отчёта компании по улице}
end
Then /^Я вижу список (активных|всех) компаний по выбранной улице в соответствии с рубрикатором$/ do |filter|
  el_id = "report_results_table"

  # составляем ряды для таблицы
  rows = ""
  if filter.eql?("активных")
    cs = Company.where("company_status_id = ? and (rubricator = ? or rubricator = 3)", CompanyStatus.active.id, @rub_filter).
        order("title")
  else
    cs = Company.where("rubricator = ? or rubricator = 3", @rub_filter).order("title")
  end
  cs.each do |c|
    rows = "#{rows}\n|#{c.title}\\n#{@company.main_branch.fact_name}, #{@company.main_branch.legel_name}|"
  end
  steps %Q{
    Then Я вижу таблицу "#{el_id}" с компаниями
      | title |
      #{rows}
        }
end
Then /^Я могу сохранить отчёт в формате (PDF|RTF|XLS)$/ do |format|
  case format.upcase
    when 'PDF'
      el_id = 'report_export_pdf'
    when 'RTF'
      el_id = 'report_export_rtf'
    when 'XLS'
      el_id = 'report_export_xls'
    else
      raise "Unknown export format"
  end
  page.should have_selector("a##{el_id}")
end
Then /^Я могу попасть на страницу формирования отчёта по рубрикам$/ do
  page.should have_content("По рубрике")
  find("a[href='#{report_company_by_rubric_path}'][text()='Показать']").click
  current_path.should eq(report_company_by_rubric_path)
end
When /^Я нахожусь на странице отчётов по рубрике$/ do
  2.times { FactoryGirl.create :company_active }
  2.times { FactoryGirl.create :company_archived }

  @rubric = FactoryGirl.create :rubric
  Company.all.each do |c|
    c.rubrics << @rubric
    c.save
  end

  visit report_company_by_rubric_path
end
Then /^Я (|не) могу сформировать отчёт по рубрике$/ do |negate|
  s = negate.eql?("не") ? "не активна" : "активна"
  step %Q{Кнопка "do_report_by_rubric" - "#{s}"}
end
When /^Я заполняю параметры отчёта по рубрике для компаний (активные|архивные|все)$/ do |filter|
  @cfilter = filter
  case filter
    when "активные"
      choose("filter_active")
      @cfilter = :active
    when "архивные"
      choose("filter_archived")
      @cfilter = :archived
    else
      choose("filter_all")
      @cfilter = :all
  end
  steps %Q{
    When Я выбираю "#{@rubric.name}" из элемента "report_rubric"
    And Кнопка "do_report_by_rubric" - "активна"
  }
  click_button("Показать")
end
Then /^Я вижу список компаний в соответствии с фильтром$/ do
  case @cfilter.to_sym
    when :active
      cs = Company.active
    when :archived
      cs = Company.archived
    else
      cs = Company.all
  end

  cs.find_all{|company| company.rubrics.include?(@rubric)}.each do |c|
    page.should have_content(c.title)
  end
end