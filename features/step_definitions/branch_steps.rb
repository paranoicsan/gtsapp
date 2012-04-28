# encoding: utf-8
When /^Я создаю филиал с фактическим названием "([^"]*)" для компании "([^"]*)"$/ do |bname, cname|
  company = Company.find_by_title cname
  #noinspection RubyResolve
  visit company_path company
  click_link "Добавить филиал"
  fill_in "branch_legel_name", :with => "Legel name - #{bname}"
  fill_in "branch_fact_name", :with => bname
  select "МУП", :from => "branch_form_type_id"
  click_button "Сохранить"
end
When /^Я вижу "([^"]*)" в списке филиалов$/ do |bname|
  page.should have_content(bname)
end
When /^Существует филиал "([^"]*)" в компании "([^"]*)"$/ do |bname, cname|
  step %{Я создаю филиал с фактическим названием "#{bname}" для компании "#{cname}"}
end
When /^Я удаляю филиал "([^"]*)" компании "([^"]*)"$/ do |bname, cname|
  branch = find_branch(bname, cname)
  #noinspection RubyResolve
  s = branch_path branch
  page.find(%{a[href = "#{s}"][data-method = "delete"]}).click
end
Then /^Я не вижу "([^"]*)" в списке филиалов$/ do |bname|
  page.should_not have_content(bname)
end
Given /^Существуют следующие филиалы для компании "([^"]*)"$/ do |cname, table|
  # table is a | ООО       | Филиал рогов   | Юр. имя филиала рогов   |pending
  table.hashes.each do |branch|
    params = {
        :fact_name => branch[:fact_name],
        :legel_name => branch[:legel_name]
    }
    b = Branch.create! params
    #noinspection RubyResolve
    b.form_type = FormType.find_by_name branch[:form_type]
    #noinspection RubyResolve
    b.company_id = Company.find_by_title(cname).id
    b.save
  end
end


When /^Я изменяю информацию для филиала компании "([^"]*)" с факт. названием "([^"]*)" на$/ do |cname, bname, table|
  # table is a | МУП       | Филиал рогов изменённый | Юр. имя филиала рогов изменённое |pending
  @branch = find_branch(bname, cname)
  #noinspection RubyResolve
  visit edit_branch_path @branch
  table.hashes.each do |new_info|
    fill_in "branch_legel_name", :with => new_info[:legel_name]
    fill_in "branch_fact_name", :with => new_info[:fact_name]
    fill_in "branch_comments", :with => new_info[:comments]
    select new_info[:form_type], :from => "branch_form_type_id"
    click_button "Сохранить"
    break
  end
end
When /^Я вижу филиал со следующей информацией$/ do |table|
  # table is a | МУП       | Филиал рогов изменённый | Юр. имя филиала рогов изменённое | лишнее   |pending
  table.hashes.each do |info|
    page.should have_content info[:fact_name]
    page.should have_content info[:legel_name]
    page.should have_content info[:form_type]
    page.should have_content info[:comments]
    break
  end
end
When /^Я нахожусь на странице филиала "([^"]*)" компании "([^"]*)"$/ do |bname, cname|
  @branch = find_branch bname, cname
  #noinspection RubyResolve
  visit branch_path(@branch)
end
When /^Я вижу текст "([^"]*)"$/ do |title|
  save_and_open_page
  page.should have_content title
end