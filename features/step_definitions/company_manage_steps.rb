# encoding: utf-8
When /^Я создаю новую компанию с названием "([^"]*)"$/ do |company_title|
  #noinspection RubyResolve
  visit new_company_path
  fill_in "company_title", :with => company_title
  click_button "Сохранить"
end

When /^Компания имеет статус "([^"]*)"$/ do |status_name|
  find("#company_status").should have_content(status_name)
  page.should_not have_content("Активировать")
end

Given /^Существуют следующие компании$/ do |table|
  table.hashes.each do |company|
    params = {
        :title => company[:title]
    }
    params[:company_status_id] = company[:status_id] if company[:status_id]
    Company.create! params
  end
end

When /^Существуют следующие формы собственности$/ do |table|
  # table is a | ООО  |pending
  table.hashes.each do |forms|
    FormType.create! :name => forms[:name]
  end
end

When /^Я нахожусь на странице компании "([^"]*)"$/ do |company_name|
  #noinspection RubyResolve
  @company = Company.find_by_title company_name
  #noinspection RubyResolve
  visit company_path @company
end

When /^Я перехожу на страницу компании "([^"]*)"$/ do |cname|
  step %{Я нахожусь на странице компании "#{cname}"}
end

When /^Я вижу одинаковую дату создания и дату изменения компании$/ do
  updated = find(:xpath, "//div[@id='updated']").text.split
  added = find(:xpath, "//div[@id='added']").text.split
  assert added[0] == updated[0], "Даты не совпадают."
end

When /^Я вижу, что "([^"]*)" компании - "([^"]*)"$/ do |uposition, uname|
  i = 0
  pos = 'N\A'
  case uposition
    when "автор"
      pos = "added"
      i = 1
    when "редактор"
      pos = "updated"
      i = 2 # т.к. у метки изменения ещё указано время
    else
      puts "Нет такого варианта"
  end
  s = find(:xpath, "//div[@id='#{pos}']").text.split
  assert s[i] == uname, "Имя пользователя не совпадает."
end

When /^Я активирую компанию "([^"]*)"$/ do |cname|
  @company = Company.find_by_title cname
  #noinspection RubyResolve
  s = activate_company_path @company
  find("a[href='#{s}']").click
end

Then /^Я не могу активировать компанию$/ do
  page.should_not have_content("Активировать")
end

When /^Я добавляю следующие компании$/ do |table|
  table.hashes.each do |row|
    step %{Я создаю новую компанию с названием "#{row[:title]}"}
  end
end

When /^Я создаю новую компанию через веб-интерфейс с параметрами$/ do |table|
  # table is a | Рога и копыта | Заявка с сайта |pending
  table.hashes.each do |param|
    #noinspection RubyResolve
    visit new_company_path
    fill_in "company_title", :with => param[:title]
    select param[:source_name], :from => "company_company_source_id"
    click_button "Сохранить"
  end
end

When /^Существует компания с параметрами$/ do |table|
  # table is a | Рога и копыта | Заявка с сайта |pending
  table.hashes.each do |param|
    cs = CompanySource.find_by_name param[:source_name]
    params = {
        :title => param[:title],
        :company_source_id => cs.id
    }
    company = Company.create params
    company.save
  end
end

When /^Я изменяю компанию "([^"]*)" параметрами$/ do |cname, table|
  company = Company.find_all_by_title cname
  #noinspection RubyResolve
  visit edit_company_path company
  table.hashes.each do |param|
    select param[:source_name], :from => "company_company_source_id"
  end
  click_button "Сохранить"
end

When /^Я выбираю истоник "([^"]*)"$/ do |source_name|
  select source_name, :from =>"company_company_source_id"
end

Then /^Я вижу выпадающее меню с ключом "([^"]*)" с данными$/ do |select_id, table|
  # table is a | t_agent  |pending
  params = []
  table.hashes.each do |row|
    params << row[:username]
  end
  page.should have_select(select_id, :options => params)
end

When /^Я ([^"]*)вижу слой с ключом "([^"]*)"$/ do |arg, select_id|
  xpth = "//div[@id='#{select_id}']"
  b = arg == "не" ? false : true
  page.find(:xpath, xpth).visible? == b
end