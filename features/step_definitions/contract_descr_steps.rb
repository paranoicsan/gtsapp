# Encoding: utf-8

When /^Для него существуют (\d+) продукта$/ do |cnt|
  cnt.to_i.times do
    FactoryGirl.create :product, contract: @contract
  end
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