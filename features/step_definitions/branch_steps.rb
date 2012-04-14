# encoding: utf-8
When /^Я создаю филиал с фактическим названием "([^"]*)" для компании "([^"]*)"$/ do |bname, cname|
  company = Company.find_by_title cname
  #noinspection RubyResolve
  visit company_path company
  click_link "Добавить филиал"
  fill_in "branch_legel_name", :with => "Legel name - #{bname}"
  fill_in "branch_fact_name", :with => bname
  select "МУП", :from => "branch_form_type_id"
  click_button "Добавить"
end
When /^Я вижу "([^"]*)" в списке филиалов$/ do |bname|
  page.should have_content(bname)
  save_and_open_page
end