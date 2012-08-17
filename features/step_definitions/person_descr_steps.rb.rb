# Encoding: utf-8

Then /^Я вижу список персон$/ do
  # составляем ряды для таблицы
  rows = ""
  @company.persons.each do |p|
    rows = "#{rows}\n|#{p.position}|#{p.full_name}|#{p.phone}|#{p.email}|"
  end
  steps %Q{
    When Я вижу таблицу "people" с персонами
      | position | full_name | phone | email |
      #{rows}
  }
end
When /^Я добавляю персону к компании$/ do
  step %Q{Я нажимаю на ссылку "Создать" с ключом "company_person_add"}
  row = person_row person_attributes
  steps %Q{
    When Я ввожу информацию о персоне
      |position|second_name|name|middle_name|phone|email|
      #{row}
  }
end
When /^Я удаляю одну персону$/ do
  click_link("compane_person_delete_link")
end
When /^Я изменяю одну персону$/ do
  click_link("company_person_edit_link")
  row = person_row person_attributes
  steps %Q{
    When Я ввожу информацию о персоне
      |position|second_name|name|middle_name|phone|email|
      #{row}
  }
end
When /^Я нахожусь на странице изменения персоны$/ do
  @company = @company ? @company : create_company
  @person = @person ? @person : create_person(@company)
  visit edit_person_path(@person)
end
When /^Я не указываю параметр "([^"]*)"$/ do |attr_name|
  elem_id = attr_id_by_name attr_name
  step %Q{Я ввожу " " в поле "#{elem_id}"}
end
Then /^Поле для параметра "([^"]*)" подсвечивается красным$/ do |attr_name|
  elem_id = group_attr_id_by_name attr_name
  step %Q{Элемент "#{elem_id}"  имеет класс "error"}
end
When /^Я указываю неверный адрес Email$/ do
  step %Q{Я ввожу "dsdsdsds" в поле "person_email"}
end
Then /^Я не могу ввести буквы в поле для телефона$/ do
  step %Q{Я ввожу "dsdsdsds" в поле "person_phone"}
  step %Q{Я вижу "" в поле "person_phone"}
end