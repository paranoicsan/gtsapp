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
When /^Существует филиал с (\d+) телефонами$/ do |cnt|
  @branch = @branch ? @branch : FactoryGirl.create(:branch)
  cnt.to_i.times do
    FactoryGirl.create :phone, branch_id: @branch.id, order_num: @branch.next_phone_order_index
  end
end
Then /^Я вижу список телефонов по индексу отображения$/ do
  table_id = 'phones'

  # составляем ряды для таблицы
  rows = ""
  @branch.phones_by_order.each do |p|
    rows = "#{rows}\n|#{p.order_num}|"
  end
  steps %Q{
    Then Я вижу таблицу "#{table_id}" с компаниями
      | order_num |
      #{rows}
  }

end
Then /^Я вижу список телефонов по индексу отображения на странице компании$/ do
  # Нажимаем на кнопку показа телефоно
  within '#phone_list' do
    id = @branch.id
    find("#show_phones_#{id}").click
  end
  step %Q{Я  вижу список телефонов для филиала на странице компании}
end
When /^Я активирую закладку "([^"]*)"$/ do |tab_title|
  click_link(tab_title)
end
Then /^Я не вижу ссылки для удаления филиалов$/ do
  xpth = "//table[@id='websites']"
  page.should have_selector :xpath, xpth
  within :xpath, xpth do
    all(:xpath, '//td').each do |node|
      node.should_not have_selector 'btn_branch_delete'
    end
  end
end