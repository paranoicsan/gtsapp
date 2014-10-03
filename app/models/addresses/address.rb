# == Schema Information
#
# Table name: addresses_addresses
#
#  id            :integer          not null, primary key
#  house         :string(255)
#  entrance      :string(255)
#  case          :string(255)
#  stage         :string(255)
#  office        :string(255)
#  cabinet       :string(255)
#  other         :string(255)
#  pavilion      :string(255)
#  litera        :string(255)
#  district_id   :integer
#  city_id       :integer
#  street_id     :integer
#  post_index_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  branch_id     :integer
#

class Addresses::Address < ActiveRecord::Base
  belongs_to :district
  belongs_to :city
  belongs_to :street
  belongs_to :post_index
  belongs_to :branch, class_name: 'Branches::Branch'

  validates_presence_of :branch
  validates_presence_of :city, :message => 'Укажите населённый пункт'
  validates_presence_of :street, :message => 'Укажите улицу'

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
