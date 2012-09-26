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
  branch = FactoryGirl.create :branch, company_id: @company.id
  @address = FactoryGirl.create :address, branch_id: branch.id
  visit report_company_by_street_path
end
