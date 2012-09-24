# encoding: utf-8
module AddressHelpers

  ##
  # Создаёт улицы для одного населённого пункта
  # @param [Integer] Количество улиц, которое надо создать
  # @return [City] Созданный город, для которого создаются улицы
  def create_streets_for_city(cnt=10)
    city = FactoryGirl.create :city
    cnt.times do
      FactoryGirl.create :street, city_id: city.id
    end
    city
  end

end

World(AddressHelpers)