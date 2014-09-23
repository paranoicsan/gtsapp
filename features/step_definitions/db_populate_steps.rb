# encoding: utf-8
When /^Существуют определённые статусы компаний$/ do
  Status.delete_all
  create_company_statuses
end
When /^Существуют определённые источники информации$/ do
  Source.delete_all
  create_company_sources
end