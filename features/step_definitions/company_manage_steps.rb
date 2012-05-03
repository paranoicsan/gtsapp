# encoding: utf-8
When /^Я создаю новую компанию с названием "([^"]*)"$/ do |company_title|
  #noinspection RubyResolve
  visit new_company_path
  fill_in "company_title", :with => company_title
  click_button "Сохранить"
end
When /^Существуют следующие статусы компаний$/ do |table|
  table.hashes.each do |status|
    CompanyStatus.create! :name => status[:name]
  end
end
When /^Компания имеет статус "([^"]*)"$/ do |status_name|
  find("#company_status").should have_content(status_name)
end
Given /^Существуют следующие компании$/ do |table|
  table.hashes.each do |company|
    params = {
        :title => company[:title]
    }
    params[:company_status_id] = company[:status_id] if company[:status_id]
    Company.create! params
  end
end
When /^Существуют следующие формы собственности$/ do |table|
  # table is a | ООО  |pending
  table.hashes.each do |forms|
    FormType.create! :name => forms[:name]
  end
end
When /^Я нахожусь на странице компании "([^"]*)"$/ do |company_name|
  @company = Company.find_by_title company_name
  #noinspection RubyResolve
  visit company_path @company
end
When /^Я перехожу на страницу компании "([^"]*)"$/ do |cname|
  step %{Я нахожусь на странице компании "#{cname}"}
end
When /^Я вижу одинаковую дату создания и дату изменения компании$/ do
  updated = find(:xpath, "//div[@id='updated']").text.split
  added = find(:xpath, "//div[@id='added']").text.split
  assert added[0] == updated[0], "Даты не совпадают."
end
When /^Я вижу, что "([^"]*)" компании - "([^"]*)"$/ do |uposition, uname|
  i = 0
  pos = 'N\A'
  case uposition
    when "автор"
      pos = "added"
      i = 1
    when "редактор"
      pos = "updated"
      i = 2 # т.к. у метки изменения ещё указано время
    else
      puts "Нет такого варианта"
  end
  s = find(:xpath, "//div[@id='#{pos}']").text.split
  assert s[i] == uname, "Имя пользователя не совпадает."
end