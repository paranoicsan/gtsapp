# encoding: utf-8
When /^Для филиала "([^"]*)" компании "([^"]*)" существует телефон$/ do |bname, cname, table|
  # table is a |true   |true    |true|false|             |521627|1      |true       |pending
  #|contact|director|fax|mobile|mobile_prefix|name|order_num|publishable|
  @branch = find_branch bname, cname
  table.hashes.each do |ph|
    ph[:branch_id] = @branch.id
    @phone = create_phone ph
    break
  end
end
When /^Для филиала "([^"]*)" компании "([^"]*)" существуют телефоны$/ do |bname, cname, table|
  # table is a |true   |true    |true|false|             |521627|1      |true       |pending
  #|contact|director|fax|mobile|mobile_prefix|name|order_num|publishable|
  @branch = find_branch bname, cname
  table.hashes.each do |ph|
    ph[:branch_id] = @branch.id
    @phone = create_phone ph
  end
end
Then /^Я вижу информацию этого телефона$/ do
  # определяем порядок, в котором отображается телефонная информация
  #noinspection RubyResolve
  rows = [
    @phone.name,
    @phone.mobile.to_s,
    @phone.mobile_refix.to_s,
    @phone.contact.to_s,
    @phone.director.to_s,
    @phone.fax.to_s,
    @phone.order_num.to_s,
    @phone.publishable.to_s,
    'Изменить',
    'Удалить'
  ]
  page.should have_table('phones', :rows => [rows])
end
When /^Я удаляю адрес$/ do
  click_link 'Удалить'
end
When /^Я создаю телефон с информацией$/ do |table|
  #noinspection RubyResolve
  visit new_branch_phone_path(@branch)
  table.hashes.each do |phone_params|
    page.fill_in 'phone_name', :with => phone_params[:name]
    page.fill_in 'phone_order_num', :with => phone_params[:order_num]
    page.fill_in 'phone_mobile_refix', :with => phone_params[:mobile_refix]
    page.check 'phone_publishable' if phone_params[:publishable] == "true"
    page.check 'phone_fax' if phone_params[:fax] == "true"
    page.check 'phone_director' if phone_params[:director] == "true"
    page.check 'phone_contact' if phone_params[:contact] == "true"
    page.check('phone_mobile') if phone_params[:mobile] == "true"
    page.click_button 'Сохранить'
    break
  end
  @phone = @branch.phones.first
end
Then /^Я попадаю на страницу созданного телефона$/ do
  #noinspection RubyResolve
  assert current_path == phone_path(@phone), 'Нет перехода на страницу телефона после создания'
end
When /^Я вижу информацию ведённого телефона$/ do
  within('div#phone_info') do
    page.should have_content(@phone.name)
    #noinspection RubyResolve
    page.should have_content(@phone.mobile.to_s)
    page.should have_content(@phone.mobile_refix.to_s)
    page.should have_content(@phone.contact.to_s)
    #noinspection RubyResolve
    page.should have_content(@phone.director.to_s)
    #noinspection RubyResolve
    page.should have_content(@phone.fax.to_s)
    page.should have_content(@phone.order_num.to_s)
    #noinspection RubyResolve
    page.should have_content(@phone.publishable.to_s)
  end
end
When /^Изменяю телефон новой информацией$/ do |table|
  #noinspection RubyResolve
  visit edit_phone_path(@phone)
  table.hashes.each do |phone_params|
    page.fill_in 'phone_name', :with => phone_params[:name]
    page.fill_in 'phone_order_num', :with => phone_params[:order_num]
    page.fill_in 'phone_mobile_refix', :with => phone_params[:mobile_refix]
    page.check 'phone_publishable' if phone_params[:publishable] == "true"
    page.check 'phone_fax' if phone_params[:fax] == "true"
    page.check 'phone_director' if phone_params[:director] == "true"
    page.check 'phone_contact' if phone_params[:contact] == "true"
    page.check('phone_mobile') if phone_params[:mobile] == "true"
    page.click_button 'Сохранить'
    break
  end
  @phone = @branch.phones.first
end

Then /^Я вижу таблицу "([^"]*)" с телефонами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    row.each_with_index do |data, i|

      row_xpth = "//table[@id='#{table_id}']/tr[#{idx}]/td[#{i+1}]"

      re = /^cb_(.*)/
      if re.match(data[0])
        v = data[1] == 'true' ? true: false
        v ? page.has_checked_field?(data[0]) : !page.has_checked_field?(data[0])
      else
        find(:xpath, row_xpth).text.should == data[1]
      end

    end
    idx += 1
  end
  # здесь проверяем на количество рядов
  page.should_not have_selector(:xpath, "//table[@id='#{table_id}']/*/tr[#{idx}]")
end
When /^Я удаляю телефон$/ do
  find("a[href='#{phone_path(@phone)}'][text()='Удалить']").click
end