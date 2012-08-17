class ProductType < ActiveRecord::Base
  has_many :products
  ##
  # Вовзращает объект бонусного продукта
  # @return ProductType
  def bonus_product
    ProductType.find(self.bonus_product_id) if self.bonus_product_id
  end
end
