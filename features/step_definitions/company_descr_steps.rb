# Encoding: utf-8

When /^Я вижу, что статус компании - "([^"]*)"$/ do |value|
  sleep 3
  step %Q{Я вижу параметр "Статус:" как "#{value}"}
end
When /^Я вижу введённую причину удаления$/ do
  step %Q{Я вижу параметр "Причина удаления:" как "#{@company.reason_deleted_on}"}
end
Then /^Я не могу удалить компанию$/ do
  page.should_not have_link('company_delete_link')
end
Then /^Я не могу удалить компанию без ввода причины удаления$/ do
  step %Q{Кнопка "btn_reason_delete_submit" - "не активна"}
end
Then /^Я вижу (\d+) компаний, поставленных на удаление$/ do |arg|
  step %Q{Я вижу только #{arg} рядов в таблице "companies_queued_for_delete"}
end
When /^Я отменяю удаление компании$/ do
  step %Q{Я нажимаю на ссылку "Отменить удаление" с ключом "company_undelete_link"}
end
When /^Я вижу (\d+) компаний в таблице на удалении$/ do |cnt|
  step %Q{Я вижу только #{cnt} рядов в таблице "companies_queued_for_delete"}
end
When /^Я отменяю удаление компании любой компании$/ do
  # ищем первую попавшуюся компанию и отменяем ей удаление
  click_link('company_undelete_link')
end
When /^У неё существуют (\d+) персоны$/ do |cnt|
  cnt.to_i.times do
    @person = create_person @company # последняя созданная будет глобальной
  end
  visit company_path(@company)
end
Then /^Я попадаю на страницу компании$/ do
  current_path.should eq(company_path(@company))
end
When /^Я нахожусь на странице создания компании$/ do
  visit new_company_path
end
Then /^Я не могу сохранить компанию$/ do
  step %Q{Кнопка "company_save" - "не активна"}
end
Then /^Поле для названия подсвечиватеся красным$/ do
  step %Q{Элемент "title_group"  имеет класс "error"}
end
When /^Я ввожу название, которое уже занято$/ do
  step %Q{Я ввожу "#{@company.title}" в поле "company_title"}
  sleep 3
end
When /^Я вижу сообщение, что имя занято$/ do
  step %Q{Я вижу сообщение "Компания с таким названием уже зарегистрирована"}
end
When /^Для компании существуют (\d+) договора$/ do |cnt|
  FactoryGirl.create :contract_status_active
  ss = FactoryGirl.create :contract_status_suspended
  FactoryGirl.create :contract_status_inactive

  @company = @company ? @company : create_company
  cnt.to_i.times do
    @contract = FactoryGirl.create :contract, company: @company, contract_status: ss
  end
  visit company_path(@company)
end
When /^Для компании существуют (\d+) активных договора$/ do |cnt|
  step %Q{Для компании существуют #{cnt} договора}
  @company.contracts.each do |c|
    Contract.activate c.id
  end
end
When /^Для компании существуют (\d+) договора на рассмотрении$/ do |cnt|
  step %Q{Для компании существуют #{cnt} договора}
  @company.contracts.each do |c|
    puts c.contract_status.inspect
    c.contract_status = ContractStatus.pending
    puts c.contract_status.inspect
  end
end
When /^Существует (\d+) компаний на рассмотрении$/ do |cnt|
  step %Q{Существует #{cnt} компаний}
  s = CompanyStatus.suspended ? CompanyStatus.suspended : FactoryGirl.create(:company_status_suspended)

  unless CompanyStatus.active
    FactoryGirl.create :company_status_active
  end

  Company.all.each do |c|
    c.company_status = s
    c.save
  end
end
Then /^Я (|не) вижу список компаний на рассмотрении$/ do |negate|
  table_id = 'suspended_companies_list'
  if negate.eql?('не')
    page.should_not have_selector("table##{table_id}")
  else
    # составляем ряды для таблицы
    rows = ""
    Company.all.each do |c|
      rows = "#{rows}\n|#{c.title}|"
    end
    steps %Q{
      Then Я вижу таблицу "#{table_id}" с компаниями
        | fact_name |
        #{rows}
    }
  end

end
Then /^Я (|не) могу активировать компанию$/ do |negate|
  s = activate_company_path(@company)
  if negate.eql?('не')
    page.should_not have_link('Активировать', href: s)
  else
    link = page.find("a[href='#{s}'][text()='Активировать']")
    link.click
    step %Q{Я не вижу список компаний на рассмотрении}
  end

end
When /^Я нахожусь на странице компании на рассмотрении$/ do
  step %Q{Существует 1 компаний на рассмотрении}
  visit company_path @company
end
Then /^Я (|не) могу активировать компанию со странице просмотра$/ do |negate|
  puts @company.company_status.inspect
  s = activate_company_path(@company)
  if negate.eql?('не')
    page.should_not have_link('Активировать', href: s)
  else
    link = page.find("a[href='#{s}']")
    link.click
    step %Q{Я не могу активировать компанию со странице просмотра}
  end
end
When /^Существует (\d+) компаний, добавленных мною$/ do |cnt|
  step %Q{Существует #{cnt} компаний на рассмотрении}
  Company.all.each do |c|
    c.author_user_id = @user.id
    c.save
  end
end
When /^Существует компания с (\d+) адресами электронной почты$/ do |cnt_email|
  steps %Q{
    Given Существует 1 компаний
    And Для компании существуют 1 филиалов
  }
  @branch = @company.branches.first
  cnt_email.to_i.times do
    @branch.emails << FactoryGirl.create(:email, branch_id: @branch.id)
  end
end
Then /^Я вижу все адреса электронной почты на странице компании$/ do
  visit company_path(@company)
  page.should have_content(@branch.all_emails_str)
end
When /^Существует компания с (\d+) веб-сайтами$/ do |cnt|
  steps %Q{
    Given Существует 1 компаний
    And Для компании существуют 1 филиалов
  }
  @branch = @company.branches.first
  cnt.to_i.times do
    @branch.websites << FactoryGirl.create(:website)
  end
end
Then /^Я вижу все адреса веб-сайтов на странице компании$/ do
  visit company_path(@company)
  page.should have_content(@branch.all_websites_str)
end
When /^Я обращаю внимание администратора на компанию$/ do
  step %Q{Я нажимаю на ссылку "Отправить администратору" с ключом "company_request_attention_link"}
end
When /^Я ввожу причину обращения$/ do
  step %Q{Кнопка "btn_reason_need_attention_submit" - "не активна"}
  step %Q{Я ввожу "#{Faker::Lorem.sentence}" в поле "reason_attention_on_ta"}
  step %Q{Кнопка "btn_reason_need_attention_submit" - "активна"}
end
When /^Я вижу введённую причину обращения$/ do
  step %Q{Я вижу параметр "Причина:" как "#{@company.reason_need_attention_on}"}
end
When /^Я отправляю причину$/ do
  find_button('btn_reason_need_attention_submit').click
end
When /^Я не могу запросить внимание без указания причины$/ do
  step %Q{Кнопка "btn_reason_need_attention_submit" - "не активна"}
end
Then /^Я не могу запросить внимание$/ do
  page.should_not have_selector("div#need_attention")
end
When /^Я нахожусь на странице компании, с запрошенным вниманием администратора$/ do
  @company = create_company
  @company.reason_need_attention_on = Faker::Lorem.sentence
  @company.company_status = CompanyStatus.need_attention
  @company.save
  visit company_path @company
end
When /^Я нахожусь на странице активной компании$/ do
  @company = create_company
  @company.company_status = CompanyStatus.active
  @company.save
  visit company_path @company
end
When /^Существует (\d+) компаний с запрошенным вниманием$/ do |cnt|
  step %Q{Существует #{cnt} компаний}

  Company.all.each do |c|
    c.company_status = CompanyStatus.need_attention
    c.reason_need_attention_on = Faker::Lorem.sentence
    c.save
  end
end
Then /^Я (|не) вижу список компаний с запрошенным вниманием$/ do |negate|
  table_id = 'need_attention_companies_list'
  if negate.eql?('не')
    page.should_not have_selector("table##{table_id}")
  else
    # составляем ряды для таблицы
    rows = ""
    Company.all.each do |c|
      rows = "#{rows}\n|#{c.title}|#{c.reason_need_attention_on}|"
    end
    steps %Q{
      Then Я вижу таблицу "#{table_id}" с компаниями
        | fact_name | reason_need_attention_on |
        #{rows}
    }
  end
end
When /^Я отправляю компанию на доработку$/ do
  step %Q{Я нажимаю на ссылку "На доработку" с ключом "company_need_improvement_link"}
end
When /^Я ввожу причину необходимости доработки$/ do
  step %Q{Кнопка "btn_reason_need_improvement_submit" - "не активна"}
  step %Q{Я ввожу "#{Faker::Lorem.sentence}" в поле "reason_improvement_on_ta"}
  step %Q{Кнопка "btn_reason_need_improvement_submit" - "активна"}
end
When /^Я вижу введённую причину доработки$/ do
  step %Q{Я вижу параметр "Причина:" как "#{@company.reason_need_improvement_on}"}
end
When /^Я отправляю причину доработки$/ do
  find_button('btn_reason_need_improvement_submit').click
end
Then /^Я не могу отправить на доруботку без указания причины$/ do
  step %Q{Кнопка "btn_reason_need_improvement_submit" - "не активна"}
end
Then /^Я не могу отправить компанию на доработку$/ do
  page.should_not have_selector("a#company_need_improvement_link")
end
When /^Я нахожусь на странице архивной компании$/ do
  @company = @company ? @company : FactoryGirl.create(:company)
  step %Q{Существует 1 компаний в архиве}
  visit company_path(@company)
end
Then /^Я (|не) вижу список компаний на доработке$/ do |negate|
  table_id = 'need_improvement_companies_list'
  if negate.eql?('не')
    page.should_not have_selector("table##{table_id}")
  else
    # составляем ряды для таблицы
    rows = ""
    Company.all.each do |c|
      rows = "#{rows}\n|#{c.title}|#{c.reason_need_improvement_on}|"
    end
    steps %Q{
      Then Я вижу таблицу "#{table_id}" с компаниями
        | fact_name | reason_need_improvement_on |
        #{rows}
          }
  end
end
Then /^Я (|не) вижу список компаний на доработке, созданные мною$/ do |negate |
  table_id = 'need_improvement_companies_list'
  if negate.eql?('не')
    page.should_not have_selector("table##{table_id}")
  else
    # составляем ряды для таблицы
    rows = ""
    Company.need_improvement_list_by_user(@user.id).each do |c|
      rows = "#{rows}\n|#{c.title}|#{c.reason_need_improvement_on}|"
    end
    steps %Q{
      Then Я вижу таблицу "#{table_id}" с компаниями
        | fact_name | reason_need_improvement_on |
        #{rows}
          }
  end
end
