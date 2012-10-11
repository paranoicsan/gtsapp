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
  FactoryGirl.create :address, city_id: @city.id, street_id: street.id

  click_link('Удалить')
  page.driver.browser.switch_to.alert.accept
  page.should have_content("Улица не может быть удалена. Она используется по крайней мере одним филиалом")
end
Then /^Я могу добавить улицу$/ do
  find_link('Добавить улицу').click
  current_path.should eq(new_street_path)
end
When /^Я нахожусь на странице создания улицы$/ do
  @city = @city ? @city : FactoryGirl.create(:city)
  visit new_street_path
end
Then /^Я не могу сохранить улицу без названия$/ do
  el_id = "btn_street_save"
  step %Q{Кнопка "#{el_id}" - "не активна"}
end
Then /^Я не могу сохранить улицу без населённого пункта$/ do
  step %Q{Я не могу сохранить улицу без названия}
end
Then /^Я вижу сообщение об ошибке, если добавляю улицу с уже занятым названием$/ do
  street = FactoryGirl.create :street, city_id: @city.id
  fill_in :street_name, with: street.name
  select @city.name, from: "street_city_id"
  click_button "Сохранить"
  page.should have_content("Такая улица уже есть в этом населённом пункте")
end
When /^Для города существуют (\d+) улиц$/ do |cnt|
  @city = @city? @city : create_streets_for_city(1)
  cnt.to_i.times do
    FactoryGirl.create :street, city_id: @city.id
  end
end
Then /^Я (|не) вижу ссылку для сохранения результатов в формате (.*)$/ do |negate, format|
  case format.upcase
    when 'PDF'
      el_id = 'report_export_pdf'
    when 'RTF'
      el_id = 'report_export_rtf'
    when 'XLS'
      el_id = 'report_export_xls'
    else
      raise "Unknown export format"
  end
  if negate.eql?("не")
    page.should_not have_selector("a##{el_id}")
  else
    page.should have_selector("a##{el_id}")
  end
end