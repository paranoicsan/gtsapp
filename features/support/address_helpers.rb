# encoding: utf-8
module AddressHelpers

  ##
  # Создаёт улицы для одного населённого пункта
  # @return [City] Созданный город, для которого создаются улицы
  def create_streets_for_city
    city = FactoryGirl.create :city
    10.times do
      FactoryGirl.create :street, city_id: city.id
    end
    city
  end

end

World(AddressHelpers)