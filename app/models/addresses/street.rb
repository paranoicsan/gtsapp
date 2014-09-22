# encoding: utf-8
class Addresses::Street < ActiveRecord::Base

  belongs_to :city

  has_many :street_indexes
  has_many :addresses, :dependent => :restrict

  validates_presence_of :city_id, :message => 'Выберите населённый пункт'
  validates_presence_of :name, :message => 'Укажите название'
  validates_uniqueness_of :name, :scope => :city_id,
                          :message => 'Такая улица уже есть в этом населённом пункте',
                          :case_sensitive => false

  ##
  # Форматирует выборку, чтобы в название включалось название города
  # в виде: ул/ Комсомольская (Калинингра)
  # @return {Array} Коллекцию улиц
  def self.name_with_city
    ar = []
    Street.all.each do |str|
      h = {
          id: str.id,
          name: "#{str.name} (#{str.city.name})"
      }
      ar << h
    end
    ar
  end
end
