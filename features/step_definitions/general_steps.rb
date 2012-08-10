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
  # здесь проверяем на количество рядом
  page.should_not have_selector(:xpath, "//table[@id='#{table_id}']/*/tr[#{idx}]")
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
      find(:xpath, "//*[@id='#{key}']").should have_content value
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

Then /^Я (|не) вижу элемент "([^"]*)"$/ do |negate, elem_id|
  if negate.eql?("не")
    #noinspection RubyResolve
    find("*[@id='#{elem_id}']").should_not be_visible
  else
    #noinspection RubyResolve
    find("*[@id='#{elem_id}']").should be_visible
  end
end

When /^Я выбираю "([^"]*)" из элемента "([^"]*)"$/ do |select_value, select_id|
  page.select select_value, from: select_id
end

When /^Я жду (\d+) секунд$/ do |sec|
  sleep sec.to_i
end

When /^Я нажимаю на ссылку "([^"]*)" с ключом "([^"]*)"$/ do |link_text, link_id|
  find("a[@id='#{link_id}'][text()='#{link_text}']").click
end

Then /^Я вижу таблицу "([^"]*)" с кодами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
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

When /^Я помечаю checkbox c ключом "([^"]*)"$/ do |elem_id|
  check(elem_id)
end

Then /^Элемент "([^"]*)" (|не) имеет класс "([^"]*)"$/ do |elem_id, negate, class_name|
  c =  page.find("div##{elem_id}")['class']
  if negate.eql? "не"
    assert /(#{class_name})/.match(c) == nil, "Класс назначен."
  else
    assert /(#{class_name})/.match(c) != nil, "Класс не назначен."
  end

end

Then /^Поле "([^"]*)" содержит "([^"]*)"$/ do |field_id, field_value|
  field = page.find("input##{field_id}")
  assert field["value"] == field_value, "Неверное значение поля"
end

When /^В выпадающем меню "([^"]*)" выбран пункт cо значением "([^"]*)"$/ do |select_id, select_value|
  select = page.find("select##{select_id}")
  assert select["value"] == select_value, "Неверное значение поля"
end

Then /^Элемента "([^"]*)" нет на странице$/ do |elem_id|
  page.should_not have_selector(:xpath, "//*[@id='#{elem_id}']")
end

Given /^Я выбираю "([^"]*)" из списка с автозаполнением с ключом "([^"]*)"/ do |text, list_id|
  page.execute_script %Q{ $('##{list_id}').trigger("focus"); }
  page.execute_script %Q{ $('##{list_id}').trigger("keydown"); }
  sleep 1
  page.evaluate_script %Q{ $('.ui-menu-item a:contains("#{text}")').trigger("mouseenter").trigger("click"); }
  page.execute_script %Q{ $('##{list_id}').trigger("keyup") }
end