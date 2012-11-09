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
  step %Q{Я активирую закладку "Рубрики"}
  xpth = "//table[@id='#{table_id}']"
  if table.hashes.any?
    page.should have_selector :xpath, xpth
    idx = 2 # Первый ряд занимает заголовок
    table.hashes.each do |row|
      #row_xpth = "//table[@id='#{table_id}']//tr[#{idx}]/td[1]"
      row_xpth = "//tr[(.|parent::tbody)[1]/parent::table[@id='#{table_id}']][#{idx}]/td[1]"
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
When /^Существует (\d+) рубрик$/ do |cnt|
  cnt.to_i.times do
   @rubric = FactoryGirl.create :rubric
  end
end
When /^Я нахожусь на странице просмотра списка рубрик$/ do
  visit rubrics_path
  current_path.should eq(rubrics_path)
end
Then /^Я (|не) вижу список рубрик$/ do |negate|
  sel = "table#rubrics"
  if negate.eql?('не')
    page.should_not have_selector(sel)
  else
    page.should have_selector(sel)
  end
end
Then /^Я могу удалить рубрику$/ do
  s = rubric_path(@rubric)
  page.should have_link('Удалить', href: s, method: 'delete')
  click_link('Удалить')
  step %Q{Я не вижу список рубрик}
end
Then /^Я могу добавить рубрику$/ do
  find('#btn_rubric_add').click
  current_path.should eq(new_rubric_path)
end
When /^Я нахожусь на странице создания рубрики$/ do
  visit new_rubric_path
end
Then /^Я не могу сохранить рубрику без названия$/ do
  el_id = "btn_rubric_save"
  step %Q{Кнопка "#{el_id}" - "не активна"}
end
Then /^Я вижу сообщение об ошибке, если добавляю рубрику с уже занятым названием$/ do
  fill_in :rubric_name, with: @rubric.name
  click_button "Сохранить"
  page.should have_content("Такая рубрика уже существует")
end
Then /^Я вижу сообщение об ошибке, если пытаюсь удалить рубрику, используемую в продукте$/ do
  FactoryGirl.create :product, rubric_id: @rubric.id # продукт на рубрику
  click_link('Удалить')
  page.should have_content("Рубрика используется в одной из компаний или в продукте")
end
Then /^Я вижу сообщение об ошибке, если пытаюсь удалить рубрику, используемую в компании$/ do
  company = create_company
  company.rubrics << @rubric
  company.save
  click_link('Удалить')
  page.should have_content("Рубрика используется в одной из компаний или в продукте.")
end
Then /^Я могу изменить рубрику$/ do
  visit edit_rubric_path(@rubric)
  fill_in :rubric_name, with: Faker::Lorem.words.join
  click_button "Сохранить"
  current_path.should eq(rubrics_path)
end