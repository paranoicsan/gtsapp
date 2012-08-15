# Encoding: utf-8

When /^Я вижу, что статус компании - "([^"]*)"$/ do |value|
  step %Q{Я вижу параметр "Статус:" как "#{value}"}
end

When /^Я вижу введённую причину удаления$/ do
  step %Q{Я вижу параметр "Причина удаления:" как "#{@company.reason_deleted_on}"}
end