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