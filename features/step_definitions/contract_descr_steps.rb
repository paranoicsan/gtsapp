# Encoding: utf-8

When /^Для него существуют (\d+) продукта$/ do |cnt|
  cnt.to_i.times do
    @product = FactoryGirl.create :product, contract: @contract, rubric: @contract.company.rubrics.first
  end
  visit contract_path(@contract)
end
Then /^Я вижу список продуктов$/ do
  table_id = "products"
  # составляем ряды для таблицы
  rows = ""
  @contract.products.each do |p|
    rows = "#{rows}\n|#{p.product_type.name}|#{p.rubric.name}|"
  end
  steps %Q{
    When Я вижу таблицу "#{table_id}" с продуктами
      | name | rubric |
      #{rows}
  }
end
Then /^Я не могу добавить продукт$/ do
  step %Q{Элемента "contract_product_add" нет на странице}
end
Then /^Я могу удалить продукт$/ do
  # нажимаем на кнопку
  # становится на один ряд меньше
  cnt = @contract.products.count
  click_link 'contract_product_delete'
  @contract.products.count.should eq(cnt-1)

end
Then /^Я могу добавить продукт$/ do
  row = "|#{FactoryGirl.create(:product_type).name}|#{FactoryGirl.create(:rubric).name}|#{Faker::Lorem.sentence}|"
  click_link('contract_product_add')
  steps %Q{
    When Я ввожу информацию о продукте
      |product|rubric|proposal|
      #{row}
  }
  current_path.should eq(contract_path(@contract))
end
Then /^Я могу просмотреть информацию о продукте$/ do
  click_link 'contract_product_view'
  page.should have_content(@product.product_type.name)
  page.should have_content(@product.rubric.name)
  page.should have_content(@product.proposal)
end
Then /^Я могу изменить продукт$/ do

  row = "|#{FactoryGirl.create(:product_type).name}|#{FactoryGirl.create(:rubric).name}|#{Faker::Lorem.sentence}|"

  click_link 'contract_product_edit'

  steps %Q{
    When Я ввожу информацию о продукте
      |product|rubric|proposal|
      #{row}
  }
  current_path.should eq(contract_path(@contract))

  step %Q{Я вижу список продуктов}
end
Then /^Я могу выбрать рубрику автозаполнением$/ do
  rub = @product.rubric.name
  el_id = 'product_rubric'
  steps %Q{
    When Я ввожу "#{rub}" в поле "#{el_id}"
    And Я выбираю "#{rub}" из списка с автозаполнением с ключом "#{el_id}"
  }
end
When /^Я вижу указанную ранее рубрику$/ do
  find_by_id('product_rubric_id').value.should eq(@product.rubric.id.to_s)
end
Then /^Я не могу изменить договор$/ do
  page.should_not have_link('Изменить', href: edit_contract_path(@contract))
end
Then /^Я (|не) могу удалить договор$/ do |negate|
  company = @contract.company
  s = contract_path(@contract)
  if negate.eql?('не')
    page.should_not have_link('Удалить', href: s, method: 'delete')
  else
    link = find("a[href='#{s}'][data-method='delete']")
    link.click
    current_path.should eq(company_path(company))
  end
end
Then /^Я (не|) могу активировать договор$/ do |negate|
  s = activate_contract_path(@contract)
  if negate.eql?('не')
    page.should_not have_link('Активировать', href: s)
  else
    page.find("a[href='#{s}']").click
    step %Q{Я нахожусь на странице компании}
    Contract.find(@contract.id).contract_status.should eq(ContractStatus.active)
  end
end
When /^Я вижу список договоров$/ do
  table_id = "contracts"
  # составляем ряды для таблицы
  rows = ""
  @company.contracts.each do |c|
    rows = "#{rows}\n|#{c.number}|#{c.project_code.name}|#{c.date_sign}|#{c.amount}|#{c.contract_status.name}|"
  end
  steps %Q{
    Then Я вижу таблицу "#{table_id}" с договорами
      | number | project_code | date_sign  | amount | contract_status |
      #{rows}
  }
end
When /^Я нахожусь на странице создания договора$/ do
  visit new_company_contract_path(@company)
end
When /^Я нахожусь на странице изменения договора$/ do
  visit edit_contract_path(@contract)
end
When /^Я пытаюсь сохранить договор с существующим номером$/ do
  step %Q{Я ввожу "#{Contract.first.number}" в поле "contract_number"}
  click_button('Сохранить')
end
When /^Я вижу сообщение, что такой номер уже используется$/ do
  s = 'Договор с таким номером уже существует!'
  step %Q{Я вижу сообщение "#{s}"}
end
Then /^Я не могу сохранить договор$/ do
  steps %Q{
    And Я нажимаю на кнопку с именем "Сохранить"
    Then Я вижу сообщение "Введите номер договора"
  }
end
Then /^Я не могу сохранить договор без номера$/ do
  steps %Q{
    When Я ввожу "" в поле "contract_number"
    Then Я не могу сохранить договор
  }
end
Then /^Я могу просмотреть договор$/ do
  s = contract_path(@contract)
  page.should have_link(@contract.number, href: s)
  page.find("a[href='#{s}'][text()='#{@contract.number}']").click
  current_path.should eq(s)
end
Then /^Я (не|) вижу список договоров на рассмотрении$/ do |negate|
  table_id = "suspended_contracts_list"
  if negate.eql?('не')
    page.should_not have_selector("table##{table_id}")
  else
    # составляем ряды для таблицы
    rows = ""
    @company.contracts.each do |c|
      rows = "#{rows}\n|#{c.number}|#{c.company.title}|"
    end
    steps %Q{
      Then Я вижу таблицу "#{table_id}" с договорами
        | number | company |
        #{rows}
    }
  end

end
Then /^Я могу активировать договор$/ do
  link = page.find("a[href='#{activate_contract_path(@contract)}'][text()='Активировать']")
  link.click
  step %Q{Я не вижу список договоров на рассмотрении}
end