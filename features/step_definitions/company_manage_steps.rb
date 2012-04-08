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