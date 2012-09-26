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
Then /^Я вижу результаты отчёта$/ do
  # TODO: Проверять, что таблица с результатами содержит нужную инорфмацию
  # по истории агента. Т.е. предварительно необходимо совершить несколько действий
  # А ещё вернее, надо просто добавить в таблицу несколько записей наверное.
  el_id = "agent_operations"
  page.should have_selector(el_id)
end