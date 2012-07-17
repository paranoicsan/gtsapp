class Product < ActiveRecord::Base
  has_many :contract_products
  ##
  # Вовзращает объект бонусного продукта
  # @return Product
  def bonus_product
    Product.find(self.bonus_product_id) if self.bonus_product_id
  end
end
