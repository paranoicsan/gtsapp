# Encoding: utf-8

When /^Для него существуют (\d+) продукта$/ do |cnt|
  cnt.to_i.times do
    @product = FactoryGirl.create :product, contract: @contract
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