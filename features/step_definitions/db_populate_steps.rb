# encoding: utf-8
When /^Существуют определённые статусы компаний$/ do
  CompanyStatus.delete_all
  create_company_statuses
end
When /^Существуют определённые источники информации$/ do
  CompanySource.delete_all
  create_company_sources
end