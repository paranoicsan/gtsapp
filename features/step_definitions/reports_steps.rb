# Encoding: utf-8
Then /^Я могу сформировать отчёт по агенту$/ do
  page.should have_content("Отчёт по агенту")
  find("a[href='#{report_by_agent_path}'][text()='Показать']").click
  current_path.should eq(report_by_agent_path)
end
When /^Я заполняю параметры отчёта$/ do
  create_agents # создаём набор агентов
  create_history @agent # создаём операции для указанного агента

  visit report_by_agent_path

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