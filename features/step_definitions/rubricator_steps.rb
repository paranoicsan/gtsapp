# Encoding: UTF-8
When /^Я выбираю рубрику "([^"]*)"$/ do |rname|
  select rname, :from => "select_rubrics"
end

When /^Существуют следующие рубрики$/ do |table|
  table.hashes.each do |row|
    Rubric.create! :name => row[:name], :social => row[:social]
  end
end

When /^Компания "([^"]*)" входит в следующие рубрики$/ do |cname, table|
  company = Company.find_by_title cname
  table.hashes.each do |r|
    rub = Rubric.find_by_name r[:name]
    company.rubrics << rub
  end
end

Then /^Я вижу таблицу "([^"]*)" с рубриками$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  #save_and_open_page
  if table.hashes.any?
    page.should have_selector :xpath, xpth
    idx = 2 # Первый ряд занимает заголовок
    table.hashes.each do |row|
      row_xpth = "//table[@id='#{table_id}']//tr[#{idx}]/td[1]"
      page.find(:xpath, row_xpth).text.should == row[:name]
      idx += 1
    end
  end
end

Then /^Я вижу "([^"]*)" в ряду (\d+) таблице "([^"]*)"$/ do |rub_name, row_num, table_id|
  find(:xpath, "//table[@id='#{table_id}']/*/tr[#{row_num}]/td[1]").text.should == rub_name
end

When /^Я удаляю рубрику "([^"]*)" для компании "([^"]*)"$/ do |rub_name, cname|
  company = Company.find_by_title cname
  rub = Rubric.find_by_name rub_name
  #noinspection RubyResolve
  s = company_delete_rubric_path company, rub
  page.find(%{a[href = "#{s}"]}).click
  page.driver.browser.switch_to.alert.accept
end

When /^Выпадающее меню "([^"]*)" содержит только следующие элементы$/ do |select_id, table|
  idx = 2 # первый вариант занимает предложение о выборе рубрики
  within :xpath, "//select[@id='#{select_id}']" do
    table.hashes.each do |sel|
      find(:xpath, "//option[#{idx}]").text.should == sel[:name]
      idx += 1
    end
  end
end