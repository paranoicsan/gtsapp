# Encoding: utf-8

When /^Я выполняю поиск компаний$/ do
  step %Q{Существует 1 компаний}
  # теперь в @company лежит последняя созданная компания

  @branch = FactoryGirl.create :branch, company_id: @company.id
  FactoryGirl.create :email, branch_id: @branch.id
  FactoryGirl.create :address, branch_id: @branch.id
  FactoryGirl.create :phone, branch_id: @branch.id

  steps %Q{
    And Я перехожу на страницу "Поиск"
    When Я ввожу "#{@company.title}" в поле "search_name"
    And Я ввожу "#{@branch.emails.first.name}" в поле "search_email"
    And Я выбираю "#{@branch.address.city.name}" из элемента "select_search_city"
    And Я выбираю "#{@branch.address.street.name}" из элемента "select_search_street"
    And Я ввожу "#{@branch.address.house}" в поле "search_house"
    And Я ввожу "#{@branch.address.office}" в поле "search_office"
    And Я ввожу "#{@branch.address.cabinet}" в поле "search_cabinet"
    And Я ввожу "#{@branch.phones.first.name}" в поле "search_phone"
    And Я нажимаю на кнопку "do_search"
  }
end
When /^Я перехожу на страницу просмотра найденной компании$/ do
  page.find("a[href='#{company_path(@company)}'][text()='#{@company.title}']").click
end
Then /^Я (|не) вижу ссылку для возврата к результатам поиска$/ do |negate|
  if negate.eql?('не')
    page.should_not have_link(GeneralHelpers::TEXT_LINK_BACK_TO_SEARCH)
  else
    page.should have_link(GeneralHelpers::TEXT_LINK_BACK_TO_SEARCH)
  end
end
When /^Я нахожусь на странице просмотра найденной компании после выполнения поиска$/ do
  steps %Q{
    When Я выполняю поиск компаний
    Then Я перехожу на страницу просмотра найденной компании
  }
end
When /^Я возвращаюсь к результатам поиска$/ do
  click_link(GeneralHelpers::TEXT_LINK_BACK_TO_SEARCH)
end
Then /^Я вижу заполненные ранее поля поиска$/ do
  steps %Q{
    When Поле "search_name" содержит "#{@company.title}"
    When Поле "search_email" содержит "#{@branch.emails.first.name}"
    When Поле "search_house" содержит "#{@branch.address.house}"
    When Поле "search_office" содержит "#{@branch.address.office}"
    When Поле "search_cabinet" содержит "#{@branch.address.cabinet}"
    When Поле "search_phone" содержит "#{@branch.phones.first.name}"
  }
  page.has_select?("select_search_city", selected: @branch.address.city.name)
  page.has_select?("select_search_street", selected: @branch.address.street.name)

end
When /^Я вижу те же самые результаты поиска$/ do
  row = "|#{@company.company_status.name}|#{@company.title}|"
  steps %Q{
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title |
      #{row}
  }
end