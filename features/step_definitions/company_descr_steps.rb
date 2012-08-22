# Encoding: utf-8

When /^Я вижу, что статус компании - "([^"]*)"$/ do |value|
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
  FactoryGirl.create :contract_status_suspended
  FactoryGirl.create :contract_status_inactive

  @company = @copmany ? @company : create_company
  cnt.to_i.times do
    @contract = FactoryGirl.create :contract, company: @company
  end
  visit company_path(@company)
end
When /^Для компании существуют (\d+) активных договора$/ do |cnt|
  step %Q{Для компании существуют #{cnt} договора}
  @company.contracts.each do |c|
    Contract.activate c.id
  end
end