# encoding: utf-8
When /^Я создаю новую компанию с названием "([^"]*)"$/ do |company_title|
  visit new_company_path
  fill_in "company_title", :with => 'Test user'
  fill_in "company_data_added", :with => '1111'
  fill_in "company_rubricator", :with => '1111'
  click_button "Создать"
end