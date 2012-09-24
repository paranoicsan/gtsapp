# Encoding: utf-8
When /^Я (|не) вижу список улиц$/ do |negate|
  sel = "table#streets"
  if negate.eql?('не')
    page.should_not have_selector(sel)
  else
    page.should have_selector(sel)
  end
end
When /^Я выбираю населённый пункт$/ do
  step %Q{Я выбираю "#{@city.name}" из элемента "city_id"}
  click_button "Показать"
end
Then /^Я могу удалить улицу$/ do
  s = street_path(@city.streets.first)
  page.should have_link('Удалить', href: s, method: 'delete')
end
Then /^Я вижу сообщение об ошибке, если пытаюсь удалить улицу, используемую в адресе$/ do
  street = @city.streets.first
  # сорздаём адрес на нашу улицу
  FactoryGirl.create :address, city_id: @city_id, street_id: street.id

  click_link('Удалить')
  page.driver.browser.switch_to.alert.accept
  page.should have_content("Улица не может быть удалена. Она используется по крайней мере одним филиалом")
end