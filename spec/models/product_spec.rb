#encoding: utf-8
require 'spec_helper'

describe Product do

  it "Должен возвращать объект бонусного продукта по ссылке bonus_product" do
    p1 = Product.create!({:name => 'prod_1'})
    p2 = Product.create!({:name => 'prod_2', :bonus_product_id => p1.id})
    assert p2.bonus_product.name == p1.name, 'Не работает ссылка на бонусный продукт'
  end

end
