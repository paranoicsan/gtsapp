# Encoding: utf-8

When /^Для него существуют (\d+) продукта$/ do |cnt|
  cnt.to_i.times do
    FactoryGirl.create :product, contract: @contract
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
  click_link('contract_product_add')
  current_path.should eq(new_contract_product_path(@contract))
end