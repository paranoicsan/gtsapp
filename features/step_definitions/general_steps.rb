# encoding: utf-8
When /^Я вижу сообщение "([^"]*)"$/ do |msg|
  page.should have_content(msg)
end

Then /^Я вижу надпись "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^Я не вижу таблицу "([^"]*)"$/ do |table_id|
  xpth = "//table[@id='#{table_id}']"
  page.should_not have_selector :xpath, xpth
end

Then /^Я вижу таблицу "([^"]*)" с компаниями$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    within :xpath, xpth do
      row_xpth = "//tr[#{idx}]/td[1]"
      find(:xpath, row_xpth).text.should == row[:fact_name]
    end
    idx += 1
  end
end

When /^Я вижу разбивку на страницы$/ do
  page.should have_selector("div.pagination")
end

When /^Я вижу параметр "([^"]*)" как "([^"]*)"$/ do |arg1, arg2|
  page.should have_content "#{arg1} #{arg2}"
end