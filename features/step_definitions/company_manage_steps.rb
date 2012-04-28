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
  # table is a | Рога и копыта |pending
  table.hashes.each do |company|
    Company.create! :title => company[:title]
  end
end
When /^Существуют следующие формы собственности$/ do |table|
  # table is a | ООО  |pending
  table.hashes.each do |forms|
    FormType.create! :name => forms[:name]
  end
end
When /^Я нахожусь на странице компании "([^"]*)"$/ do |company_name|
  company = Company.find_by_title company_name
  #noinspection RubyResolve
  visit company_path company
end
When /^Я перехожу на страницу компании "([^"]*)"$/ do |cname|
  step %{Я нахожусь на странице компании "#{cname}"}
end