# Encoding: utf-8

When /^Я вижу, что статус компании - "([^"]*)"$/ do |value|
  step %Q{Я вижу параметр "Статус:" как "#{value}"}
end

When /^Я вижу введённую причину удаления$/ do
  step %Q{Я вижу параметр "Причина удаления:" как "#{@company.reason_deleted_on}"}
end
Then /^Я не могу удалить компанию$/ do
  step %Q{Элемент "company_delete_link"  имеет класс "disabled"}
end
Then /^Я не могу удалить компанию без ввода причины удаления$/ do
  step %Q{Кнопка "btn_reason_delete_submit" - "не активна"}
end