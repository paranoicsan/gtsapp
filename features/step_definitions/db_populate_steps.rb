# encoding: utf-8
When /^Существуют определённые статусы компаний$/ do
  CompanyStatus.delete_all
  ["Активна", "На рассмотрении", "В архиве"].each do |status|
    CompanyStatus.create(name: status).save!
  end
end
When /^Существуют определённые источники информации$/ do
  CompanySource.delete_all
  ["Заявка с сайта", "От агента"].each do |status|
    CompanySource.create(name: status).save!
  end
end