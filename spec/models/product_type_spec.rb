#encoding: utf-8
require 'spec_helper'

describe ProductType do

  describe ".bonus_product" do
    it "Должен возвращать объект бонусного продукта по ссылке bonus_product" do
      p1 = FactoryGirl.create :product_type
      p2 = FactoryGirl.create :product_type, bonus_product_id: p1.id
      p2.bonus_product.should eq(p1)
    end
  end



end
