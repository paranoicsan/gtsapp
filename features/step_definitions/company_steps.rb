# encoding: utf-8
When /^Я создаю новую компанию с названием "([^"]*)"$/ do |company_title|
  #noinspection RubyResolve
  visit new_company_path
  fill_in "company_title", :with => company_title
  click_button "Сохранить"
  @company = Company.find_by_title company_title
end

When /^Компания имеет статус "([^"]*)"$/ do |status_name|
  #page.should have_selector(:xpath, "table[@id='company_info']/tr/td[text()[contains(., '#{status_name}')]]")
  within :xpath, "//table[@id='company_info']" do
    find(:xpath, "//tr[td//text()[contains(., '#{status_name}')]]")
  end
  #noinspection RubyResolve
  s = activate_company_path(@company)
  page.should_not have_selector("a[href='#{s}'][text() = 'Активировать']")
end

Given /^Существуют следующие компании$/ do |table|

  create_company_sources
  create_company_statuses

  table.hashes.each do |company|
    params = {
        :title => company[:title]
    }
    if company[:agent_name]
      params[:agent_id] = User.find_by_username(company[:agent_name]).id
    end
    if company[:source_name]
      params[:company_source_id] = CompanySource.find_by_name(company[:source_name]).id
    end
    params[:rubricator] = company[:rubricator] if company[:rubricator]
    params[:author_user_id] = company[:author_user_id] if company[:author_user_id]
    params[:company_status_id] = company[:status_id] if company[:status_id]

    FactoryGirl.create :company, params
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
  updated = find(:xpath, "//p[@id='updated']").text.split
  added = find(:xpath, "//p[@id='added']").text.split
  assert added[0] == updated[0], "Даты не совпадают."
end

When /^Я вижу, что "([^"]*)" компании - "([^"]*)"$/ do |uposition, uname|
  pos = 'N\A'
  case uposition
    when "автор"
      pos = "added"
    when "редактор"
      pos = "updated"
    when "статус"
      pos = "company_status"
    else
      puts "Нет такого варианта"
  end
  s = find("p[@id='#{pos}']").text.split
  assert s[2] == uname, "Не верное значение."
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
  create_company_sources
  # table is a | Рога и копыта | Заявка с сайта |pending
  table.hashes.each do |param|
    #noinspection RubyResolve
    visit new_company_path
    fill_in "company_title", :with => param[:title]
    select param[:source_name], :from => "company_company_source_id"
    click_button "Сохранить"
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
  xpth = "div[@id='#{select_id}']"
  b = arg == "не" ? false : true
  page.has_selector?(xpth, :visible => b)
end

Given /^Существуют (\d+) компаний с названиями на вариацию "([^"]*)" и параметрами$/ do |cnt, cname_base, table|

  create_company_sources
  create_company_statuses

  params = {}
  if table
    table.hashes.each do |p|
      if p[:company_status]
        params[:company_status_id] = CompanyStatus.find_by_name(p[:company_status]).id
      end
      if p[:author_user]
        params[:author] = User.find_by_username(p[:author_user])
      end
    end
  end
  Integer(cnt).times do |i|
    params[:title] = "#{cname_base}_#{i}"
    c = FactoryGirl.create :company, params
    c
  end
end

When /^Я нахожусь на странице компании$/ do
  @company = @copmany ? @company : create_company
  visit company_path @company
end

When /^Я удаляю компанию$/ do
  step %Q{Я нажимаю на ссылку "Удалить" с ключом "company_delete_link"}
end

When /^Я ввожу причину удаления$/ do
  step %Q{Кнопка "btn_reason_delete_submit" - "не активна"}
  step %Q{Я ввожу "#{Faker::Lorem.sentence}" в поле "reason_delete_on_ta"}
  step %Q{Кнопка "btn_reason_delete_submit" - "активна"}
end

When /^Я нахожусь на странице компании, поставленной на удалении$/ do
  @company = create_company
  FactoryGirl.create :company_status_on_deletion
  @company.queue_for_delete Faker::Lorem.words.join(' ')
  @company.save
  visit company_path @company
end

Given /^Существуют (\d+) компаний, поставленных на удаление$/ do |cnt|
  puts Company.count
  FactoryGirl.create :company_status_active
  FactoryGirl.create :company_status_suspended
  params = {
      company_status: FactoryGirl.create(:company_status_on_deletion),
      reason_deleted_on: Faker::Lorem.sentence
  }
  cnt.to_i.times do
    FactoryGirl.create :company, params
  end
  puts Company.count
  puts Company.queued_for_delete.count
end
When /^Существует (\d+) компаний$/ do |cnt|
  cnt.to_i.times do
    @company = FactoryGirl.create :company
  end
end