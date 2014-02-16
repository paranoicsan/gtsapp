# Encoding: utf-8
Then /^Я могу выбрать населённый пункт автозаполнением "([^"]*)"$/ do |el_id|
  city = @address ? @address.city.name : FactoryGirl.create(:city).name
  el_id = el_id.eql?('') ? 'address_city_id' : el_id
  steps %Q{
    When Я ввожу "#{city}" в поле "#{el_id}"
    And Я выбираю "#{city}" из списка с автозаполнением с ключом "#{el_id}"
  }
end
Then /^Я могу выбрать улицу с автозаполнением "([^"]*)"$/ do |el_id|
  street = @address.street.name
  el_id = el_id.eql?("") ? 'addr_address_street' : el_id
  steps %Q{
    When Я ввожу "#{street}" в поле "#{el_id}"
    And Я выбираю "#{street}" из списка с автозаполнением с ключом "#{el_id}"
  }
end
When /^Я удаляю введённый населенный пункт "([^"]*)"$/ do |el_id|
  el_id = el_id.eql?("") ? 'address_city_id' : el_id
  step %Q{Я ввожу " " в поле "#{el_id}"}
  sleep 2
end
Then /^Значение улицы сбрасывается "([^"]*)"$/ do |el_id|
  el_id = el_id.eql?("") ? 'addr_address_street' : el_id
  page.find("input##{el_id}").value.should eq("")
end
When /^Населённый пункт не выбран "([^"]*)"$/ do |el_id|
  step %Q{Я удаляю введённый населенный пункт "#{el_id}"}
end
Then /^Я не могу ввести название улицы "([^"]*)"$/ do |el_id|
  el_id = el_id.eql?("") ? 'addr_address_street' : el_id
  page.find("input##{el_id}")['disabled'].should be_true
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