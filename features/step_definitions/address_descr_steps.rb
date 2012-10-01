# Encoding: utf-8
Then /^Я могу выбрать населённый пункт автозаполнением$/ do
  city = @address ? @address.city.name : FactoryGirl.create(:city)
  el_id = 'address_city_id'
  steps %Q{
    When Я ввожу "#{city}" в поле "#{el_id}"
    And Я выбираю "#{city}" из списка с автозаполнением с ключом "#{el_id}"
  }
end
Then /^Я могу выбрать улицу с автозаполнением$/ do
  street = @address.street.name
  el_id = 'addr_address_street'
  steps %Q{
    When Я ввожу "#{street}" в поле "#{el_id}"
    And Я выбираю "#{street}" из списка с автозаполнением с ключом "#{el_id}"
  }
end
When /^Я удаляю введённый населенный пункт$/ do
  step %Q{Я ввожу " " в поле "address_city_id"}
  sleep 2
end
Then /^Значение улицы сбрасывается$/ do
  page.find("input#addr_address_street")['value'].should eq("")
end
When /^Населённый пункт не выбран$/ do
  step %Q{Я удаляю введённый населенный пункт}
end
Then /^Я не могу ввести название улицы$/ do
  page.find("input#addr_address_street")['disabled'].should be_true
end
When /^Я нахожусь на странице создания адреса$/ do
  @branch = @branch ? @branch : FactoryGirl.create(:branch)
  visit new_branch_address_path(@branch)
end
Then /^Я не могу сохранить адрес не указав населённый пункт$/ do
  step %Q{Кнопка "btn_address_save" - "не активна"}
end
Then /^Я не могу сохранить адрес не указав улицу$/ do
  step %Q{Кнопка "btn_address_save" - "не активна"}
end