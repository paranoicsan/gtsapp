# Encoding: utf-8

When /^Я нахожусь на странице создания филиала$/ do
  @company = @company ? @company : FactoryGirl.create(:company)
  visit new_company_branch_path(@company)
end
Then /^Я не могу сохранить филиал без фактического названия$/ do
  step %Q{Кнопка "btn_branch_save" - "не активна"}
end
Then /^Я не могу сохранить филиал без юридического названия$/ do
  step %Q{Кнопка "btn_branch_save" - "не активна"}
end
When /^Я нахожусь на странице изменения адреса$/ do
  @branch = @branch ? @branch : FactoryGirl.create(:branch)
  @address = FactoryGirl.create :address
  @address.street.city_id = @address.city.id
  @address.street.save
  visit edit_address_path(@address)
end
When /^Я нахожусь на странице создания телефона$/ do
  @branch = @branch ? @branch : FactoryGirl.create(:branch)
  visit new_branch_phone_path(@branch)
end
Then /^Я не могу сохранить телефон без номера$/ do
  step %Q{Кнопка "btn_phone_save" - "не активна"}
end