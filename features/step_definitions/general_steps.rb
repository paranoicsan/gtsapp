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
    row.each_with_index do |data, i|
      row_xpth = "//table[@id='#{table_id}']/*/tr[#{idx}]/td[#{i+1}]"
      find(:xpath, row_xpth).text.should == data[1]
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

When /^Существуют следующие коды проекта$/ do |table|
  table.hashes.each do |row|

    ProjectCode.create!({:name => row[:name]})
  end
end

When /^Я вижу следующую информацию$/ do |table|
  table.hashes.each do |row|
    row.each do |key, value|
      find(:xpath, "//div[@id='#{key}']").should have_content value
    end
  end
end

Then /^Я (не|) вижу ссылки "([^"]*)" в таблице "([^"]*)" в ряду "([^"]*)"$/ do |arg, link_text, table_id, row_num|
  if arg.eql?("не")
    page.find(:xpath, "//table[@id='#{table_id}']/tr[#{row_num}]").should_not have_content(link_text)
  else
    page.find(:xpath, "//table[@id='#{table_id}']/tr[#{row_num}]").should have_content(link_text)
  end
end

Then /^Я не вижу элемент "([^"]*)"$/ do |elem_id|
  page.should_not have_selector(:xpath, "id('#{elem_id}')")
end