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
    create_person @company
  end
  visit company_path(@company)
end
Then /^Я попадаю на страницу компании$/ do
  current_path.should eq(company_path(@company))
end