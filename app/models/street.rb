class Street < ActiveRecord::Base
  belongs_to :city
  has_many :street_indexes
  has_many :addresses

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
