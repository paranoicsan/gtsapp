# encoding: utf-8
When /^Я создаю договор через веб-интерфейс с параметрами$/ do |table|
  table.hashes.each do |param|
    if param[:number]
      fill_in "contract_number", :with => param[:number]
    end
    if param[:date_sign]
      date = DateTime.strptime param[:date_sign], '%e.%m.%Y'
      day = date.day.to_s
      select day , :from => "contract_date_sign_3i"
      month = I18n.backend.send(:translations)[:ru][:date][:common_month_names][date.month.to_i]
      select month, :from => "contract_date_sign_2i"
      year = date.year.to_s
      select year, :from => "contract_date_sign_1i"
    end
    if param[:amount]
      fill_in "contract_amount", :with => param[:amount]
    end
    if param[:company_legel_name]
      fill_in "contract_company_legel_name", :with => param[:company_legel_name]
    end
    if param[:person]
      fill_in "contract_person", :with => param[:person]
    end
    if param[:company_details]
      fill_in "contract_company_details", :with => param[:company_details]
    end
    if param[:number_of_dicts]
      fill_in "contract_number_of_dicts", :with => param[:number_of_dicts]
    end
    if param[:project_code]
      select param[:project_code], :from => "contract_project_code_id"
    end
    if param[:bonus]
      check "contract_bonus"
    end
  end
  click_button "Сохранить"
end

Then /^Я вижу текущую дату для поля "([^"]*)"$/ do |field_name|
  d = Date.today.strftime("%d.%m.%Y")
  page.should have_content "#{field_name} #{d}"
end

When /^Существуют следующие договора$/ do |table|
  create_contract_statuses
  table.hashes.each do |row|
    Contract.create! row
  end
end

Then /^Я вижу таблицу "([^"]*)" с договорами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    row.each_with_index do |data, i|
      row_xpth = "//table[@id='#{table_id}']/tr[#{idx}]//td[#{i+1}]"
      find(:xpath, row_xpth).text.should == data[1]
    end
    idx += 1
  end
end

When /^Я удаляю договор с номером "([^"]*)"$/ do |cnumber|
  c = Contract.find_by_number cnumber
  #noinspection RubyResolve
  s = contract_path c
  page.find(%{a[href = "#{s}"][data-method = "delete"]}).click
end

When /^Я актвирую договор с номером "([^"]*)"$/ do |cnumber|
  c = Contract.find_by_number cnumber
  #noinspection RubyResolve
  s = activate_contract_path c
  page.find(%{a[href = "#{s}"]}).click
end

When /^Я вижу таблицу "([^"]*)" c продуктами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    row.each_with_index do |data, i|
      row_xpth = "//table[@id='#{table_id}']//tr[#{idx}]//td[#{i+1}]"
      page.find(:xpath, row_xpth).text.should == data[1]
    end
    idx += 1
  end
end

When /^Существуют следующие продукты$/ do |table|
  table.hashes.each do |row|
    ProductType.create! :name => row[:name]
  end
end

When /^Я выбираю продукт "([^"]*)"$/ do |prod_name|
  select prod_name, :from => "select_product_id"
end

When /^Я добавляю продукт "([^"]*)" к договору "([^"]*)" по прямой ссылке$/ do |prod_name, cname|
  p = ProductType.find_by_name prod_name
  c = Contract.find_by_number cname
  #noinspection RubyResolve
  visit contract_add_product_path c, p
end

When /^Существуют следующие продукты для договора "([^"]*)"$/ do |cname, table|
  c = Contract.find_by_number cname
  table.hashes.each do |row|
    prod_name = row[:name]
    # Если такой продукт уже есть, не создаем дубликат
    p = ProductType.find_by_name prod_name
    if p
      c.product_types << p
    else
      c.product_types << ProductType.create(:name => prod_name)
    end
  end
end

When /^Я удаляю продукт с названием "([^"]*)" из договора "([^"]*)"$/ do |prod_name, cname|
  p = ProductType.find_by_name prod_name
  c = Contract.find_by_number cname
  #noinspection RubyResolve
  s = contract_delete_product_path c, p
  page.find(%{a[href = "#{s}"]}).click
  page.driver.browser.switch_to.alert.accept
end

When /^Я нахожусь на странице договора$/ do
  @contract = @contract ? @contract : FactoryGirl.create(:contract)
  visit contract_path @contract
end

When /^Я нахожусь на странице (|не) активного договора$/ do |attr|
  status = attr.eql?('не') ? :contract_suspended : :contract_active
  @contract = @contract ? @contract : FactoryGirl.create(status)
  visit contract_path @contract
end

When /^Я нахожусь на странице изменения продукта$/ do
  steps %Q{
    When Я нахожусь на странице  активного договора
    And Для него существуют 1 продукта
  }
  visit edit_product_path(@product)

end