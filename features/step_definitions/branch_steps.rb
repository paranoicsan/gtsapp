# encoding: utf-8
When /^Я создаю филиал с фактическим названием "([^"]*)" для компании "([^"]*)"$/ do |bname, cname|
  @company = Company.find_by_title cname
  #noinspection RubyResolve
  visit company_path @company
  click_link "Добавить филиал"
  fill_in "branch_legel_name", :with => "Legel name - #{bname}"
  fill_in "branch_fact_name", :with => bname
  select "МУП", :from => "branch_form_type_id"
  click_button "Сохранить"
  @branch = Branch.find_by_fact_name bname
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
    c_id = Company.find_by_title(cname).id
    ft_id = FormType.find_by_name(branch[:form_type]).id
    params = {
        :fact_name => branch[:fact_name],
        :legel_name => branch[:legel_name],
        :company_id => c_id,
        :form_type_id => ft_id
    }
    b = Branch.create! params
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
  page.should have_content title
end
When /^Я вижу пометку "([^"]*)" в списке для этого филиала$/ do |title|
  puts @branch.fact_name
  row_num = branch_get_table_index @company, @branch.fact_name
  xpth_row = "//table[@id='branches']/tr[#{row_num}]/td[1]"
  find(:xpath, xpth_row).text.should == title
end
When /^Я вижу в качестве головного филиал с факт. названием "([^"]*)"$/ do |bname|

  branch = Branch.find_by_fact_name bname
  assert branch.is_main?, "Первый созданный филиал не является головным"

  row_num = branch_get_table_index @company, bname
  xpth_row = "//table[@id='branches']/tr[#{row_num}]"
  within :xpath, xpth_row do
    find(:xpath, "//td[1]").text.should == "Головной филиал"
    find(:xpath, "//td[3]").text.should == branch.fact_name
  end
end
When /^Я выбираю в качестве головного филиал с факт. названием "([^"]*)"$/ do |bname|
  row_num = branch_get_table_index @company, bname
  @branch = Branch.find_by_fact_name bname
  xpth = "//table[@id='branches']/tr[#{row_num}]/td[6]"
  within :xpath, xpth do
    click_link "Сделать головным"
  end
end
Then /^Филиал с факт. название "([^"]*)" находится в первом ряду списка$/ do |bname|
  xpth_row = "//table[@id='branches']/tr[1]" # первый ряд с данными
  within :xpath, xpth_row do
    find(:xpath, "//td[3]").text.should == bname
    find(:xpath, "//td[1]").text.should == "Головной филиал"
  end
  save_and_open_page
end