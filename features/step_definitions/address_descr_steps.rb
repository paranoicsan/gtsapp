# Encoding: utf-8

Then /^Я могу выбрать населённый пункт автозаполнением$/ do
  city = @address.city.name
  el_id = 'address_city'
  steps %Q{
    When Я ввожу "#{city}" в поле "#{el_id}"
    And Я выбираю "#{city}" из списка с автозаполнением с ключом "#{el_id}"
  }
end
Then /^Я могу выбрать улицу с автозаполнением$/ do
  street = @address.street.name
  el_id = 'address_street'
  steps %Q{
    When Я ввожу "#{street}" в поле "#{el_id}"
    And Я выбираю "#{street}" из списка с автозаполнением с ключом "#{el_id}"
  }
end