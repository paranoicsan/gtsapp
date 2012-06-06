# encoding: utf-8

When /^Я создаю договор через веб-интерфейс с параметрами$/ do |table|
  table.hashes.each do |param|
    if param[:number]
      fill_in "contract_number", :with => param[:number]
    end
  end
  click_button "Сохранить"
end

Then /^Я вижу текущую дату для поля "([^"]*)"$/ do |field_name|
  d = Date.today.strftime("%d.%m.%Y")
  page.should have_content "#{field_name} #{d}"
end