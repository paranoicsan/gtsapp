# Encoding: utf-8
Then /^Я могу попасть на страницу формирования отчёта по агенту$/ do
  page.should have_content("Отчёт по агенту")
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
  page.should have_content("Отчёт компаний по улице")
  find("a[href='#{report_company_by_street_path}'][text()='Показать']").click
  current_path.should eq(report_company_by_street_path)
end
When /^Я нахожусь на странице отчётов компаний по улице$/ do
  @company = create_company
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

  #персоны
  3.times { FactoryGirl.create :person, company_id: @company.id }


  visit report_company_by_street_path
end
When /^Я уже ввёл населенный пункт$/ do
  step %Q{Я могу выбрать населённый пункт автозаполнением}
end
Then /^Я (|не) могу сформировать отчёт компаний по улице$/ do |negate|
  s = negate.eql?("не") ? "не активна" : "активна"
  step %Q{Кнопка "do_report_company_by_street" - "#{s}"}
end
When /^Я заполняю параметры отчёта компании по улице$/ do
  steps %Q{
    When Я могу выбрать населённый пункт автозаполнением
    Then Я могу выбрать улицу с автозаполнением
    And Кнопка "do_report_company_by_street" - "активна"
  }
  click_button("Показать")
end
Then /^Я вижу список компаний по выбранной улице$/ do
  el_id = "report_results_table"

  # составляем ряды для таблицы
  rows = ""
  Company.all.each do |c|
    rows = "#{rows}\n|#{c.title}\\n#{@company.main_branch.fact_name}, #{@company.main_branch.legel_name}|"
  end
  steps %Q{
    Then Я вижу таблицу "#{el_id}" с компаниями
      | title |
      #{rows}
  }
end
When /^Я вижу список филиалов для каждой компании$/ do
  # проверка головного филиала
  branch = @company.main_branch
  s = "#{branch.fact_name}, #{branch.legel_name}, #{branch.address.full_address}"
  page.should have_content(s)

  # проверка остальных филиалов
  @company.branches_sorted.each do |b|
    unless b.is_main
      s = "#{b.fact_name}, #{b.legel_name}, #{b.address.full_address}"
      page.should have_content(s)
    end
  end
end
When /^Я вижу список телефонов для каждой компании$/ do
  @company.branches_sorted.each do |b|
    b.phones_by_order.each do |p|
      s = %Q{#{p.name_formatted} - #{p.description}}
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
    s = %Q{#{s}  #{rub.name},}
  end
  page.should have_content(s.gsub(/,$/, ''))
end