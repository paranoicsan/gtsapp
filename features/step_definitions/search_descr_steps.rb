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
    And Я ввожу "#{@branch.phones.first.name}" в поле "search_phone"
    And Я нажимаю на кнопку "do_search"
  }
end
When /^Я перехожу на страницу просмотра найденной компании$/ do
  page.find("a[href='#{company_path(@company)}'][text()='#{@company.title}']").click
end
Then /^Я (|не) вижу ссылку для возврата к результатам поиска$/ do |negate|
  if negate.eql?('не')
    page.should_not have_link("Назад к результатам поиска", href: search_path)
  else
    page.should have_link("Назад к результатам поиска", href: search_path)
  end
end