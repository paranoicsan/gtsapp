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
  #noinspection RubyResolve
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
    params = {
        :fact_name => branch[:fact_name],
        :legel_name => branch[:legel_name],
        :company_id => c_id,
    }
    if branch[:form_type]
      params[:form_type_id]  = FormType.find_by_name(branch[:form_type]).id
    end
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
  xpth_row = "//table[@id='branches']/tr[1]" # первый ряд с данными
  within :xpath, xpth_row do
    find(:xpath, "//td[3]").text.should == @branch.fact_name
    find(:xpath, "//td[1]").text.should == title
  end
end
When /^Я вижу в качестве головного филиал с факт. названием "([^"]*)"$/ do |bname|

  branch = Branch.find_by_fact_name bname
  assert branch.is_main?, "Первый созданный филиал не является головным."

  # Проверяем, что первым в списке показан головной филиал с указанным
  # фактическим названием
  xpth_row = "//table[@id='branches']/tr[2]"
  within :xpath, xpth_row do
    find(:xpath, "//td[1]").text.should == "Головной филиал"
    find(:xpath, "//td[3]").text.should == branch.fact_name
  end
end
When /^Я выбираю в качестве головного филиал с факт. названием "([^"]*)"$/ do |bname|

  @branch = Branch.find_by_fact_name bname

  # Ищем ячейку с операциями для филиала по указанному факт. названию
  within :xpath, "//table[@id='branches']/*[(th|td)/descendant-or-self::*[contains(text(), '#{bname}')]]/td[6]" do
    click_link "Сделать головным"
  end
end
Then /^Филиал с факт. название "([^"]*)" находится в первом ряду списка$/ do |bname|
  xpth_row = "//table[@id='branches']/tr[2]" # первый ряд с данными
  within :xpath, xpth_row do
    find(:xpath, "//td[3]").text.should == bname
    find(:xpath, "//td[1]").text.should == "Головной филиал"
  end
end

When /^Я ввожу "([^"]*)" в поле "([^"]*)"$/ do |wname, field_id|
  fill_in field_id, :with => wname
end

When /^Я вижу таблицу "([^"]*)" с веб-сайтами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    within :xpath, xpth do
      row_xpth = "//tr[#{idx}]/td[1]"
      find(:xpath, row_xpth).text.should == row[:name]
      #find(:xpath, row_xpth).has_text? row[:name]
    end
    idx += 1
  end
end

When /^Кнопка "([^"]*)" - "(активна|не активна)"$/ do |button_id, status|
  s = status.eql?("активна") ? "" : "disabled"
  find(:xpath, "//input[@id='#{button_id}']")['disabled'] == s
end

When /^Я нажимаю на кнопку "([^"]*)"$/ do |elem_id|
  find(:xpath, "//input[@id='#{elem_id}']")['disabled'] == ""
  click_button elem_id
end

When /^Существуют следующие веб-сайты дял филиала "([^"]*)"$/ do |bname, table|
  branch = Branch.find_by_fact_name bname
  table.hashes.each do |row|
    ws = Website.create! :name => row[:name]
    ws.save!
    #noinspection RubyResolve
    branch.websites << ws
  end
  branch.save!
end

Then /^Я не вижу ссылки "([^"]*)" в таблице "([^"]*)"$/ do |link_title, table_id|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  within :xpath, xpth do
    find(:xpath, "//td").should_not have_content link_title
  end
end

When /^Я удаляю веб-сайт "([^"]*)" из филиала "([^"]*)"$/ do |ws_name, bname|
  b = Branch.find_by_fact_name bname
  ws = b.websites.find_by_name ws_name
  #noinspection RubyResolve
  s = branch_delete_website_path b, ws
  page.find(%{a[href = "#{s}"]}).click
  page.driver.browser.switch_to.alert.accept
end

When /^Я вижу таблицу "([^"]*)" с адресами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    row_xpth = "//table[@id='#{table_id}']/*/tr[#{idx}]/td[1]"
    page.find(:xpath, row_xpth).text.should == row[:name]
    idx += 1
  end
end

