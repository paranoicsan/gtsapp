class Addresses::Address < ActiveRecord::Base
  belongs_to :district
  belongs_to :city
  belongs_to :street
  belongs_to :post_index
  belongs_to :branch, class_name: 'Branches::Branch'

  validates_presence_of :branch_id
  validates_presence_of :city_id, :message => 'Укажите населённый пункт'
  validates_presence_of :street_id, :message => 'Укажите улицу'

  # Форматирует объект адреса в строку с условными обозначениями
  # @return [string] строка адреса
  def full_address

    s = ''
    #s = s + "#{post_index.code}, " unless post_index.is_a?(NilClass)
    s = s + "#{city.name}, " unless city.is_a?(NilClass)
    #s = s + "#{district.name}, " unless district.is_a?(NilClass)
    s = s + "#{street.name} " unless street.is_a?(NilClass)
    s = s + "д. #{house}, " unless house.eql?('')
    s = s + "каб. #{cabinet}, " unless cabinet.eql?('')
    s = s + "корпус #{self.case}, " unless self.case.eql?('')
    s = s + "подъезд #{entrance}, " unless entrance.eql?('')
    s = s + "литера #{litera}, " unless litera.eql?('')
    s = s + "этаж #{stage}, " unless stage.eql?('')
    s = s + "офис #{office}, " unless office.eql?('')
    s = s + "др. #{other}, " unless other.eql?('')
    s = s + "пав. #{pavilion}, " unless pavilion.eql?('')
    s.gsub(/, $/, '')

  end

  ##
  #  Возвращает все адреса по указанной улице
  def self.by_street(street_id)
    where('street_id = ?', street_id)
  end

end