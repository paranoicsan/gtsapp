# encoding: utf-8
When /^Я создаю договор через веб-интерфейс с параметрами$/ do |table|
  table.hashes.each do |param|
    if param[:number]
      fill_in "contract_number", :with => param[:number]
    end
    if param[:date_sign]
      select_date param[:date_sign], :from => "Дата подписания"
    end
    if param[:amount]
      fill_in "contract_amount", :with => param[:amount]
    end
    if param[:company_legel_name]
      fill_in "contract_company_legel_name", :with => param[:company_legel_name]
    end
    if param[:person]
      fill_in "contract_person", :with => param[:person]
    end
    if param[:company_details]
      fill_in "contract_company_details", :with => param[:company_details]
    end
    if param[:number_of_dicts]
      fill_in "contract_number_of_dicts", :with => param[:number_of_dicts]
    end
    if param[:project_code]
      select param[:project_code], :from => "contract_project_code_id"
    end
    if param[:bonus]
      check "contract_bonus"
    end
  end
  click_button "Сохранить"
end

Then /^Я вижу текущую дату для поля "([^"]*)"$/ do |field_name|
  d = Date.today.strftime("%d.%m.%Y")
  page.should have_content "#{field_name} #{d}"
end