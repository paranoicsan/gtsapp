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

require 'spec_helper'

describe Addresses::Address do

  it 'Фабрика корректна' do
    FactoryGirl.create(:address).should be_valid
  end
  it 'Не может быть создан без филиала' do
    FactoryGirl.build(:address, branch: nil).should_not be_valid
  end
  it 'Не может быть создан без населённого пункта' do
    address = FactoryGirl.build :address, city: nil
    address.should have(1).error_on(:city)
  end
  it 'Не может быть создан без улицы' do
    address = FactoryGirl.build :address, street: nil
    address.should have(1).error_on(:street)
  end

  describe '.full_address возвращает отформатированную строку полного адреса' do

    # @param [Hash] Набор параметров, для которых формируется строка
    # @return Отформатированную строку по параметрам
    def format_address(params)

      s = ''
      #s = "#{s}, #{params[:post_index]}, " unless params[:post_index].eql?('')
      s = "#{params[:city]}, " unless params[:city].eql?('')
      #s = "#{s}, #{params[:district]}, " unless params[:district].eql?('')
      s = "#{s}#{params[:street]} " unless params[:street].eql?('')

      s = s + "д. #{params[:house]}, " unless params[:house].eql?('')
      s = s + "каб. #{params[:cabinet]}, " unless params[:cabinet].eql?('')
      s = s + "корпус #{params[:case]}, " unless params[:case].eql?('')
      s = s + "подъезд #{params[:entrance]}, " unless params[:entrance].eql?('')
      s = s + "литера #{params[:litera]}, " unless params[:litera].eql?('')
      s = s + "этаж #{params[:stage]}, " unless params[:stage].eql?('')
      s = s + "офис #{params[:office]}, " unless params[:office].eql?('')
      s = s + "др. #{params[:other]}, " unless params[:other].eql?('')
      s = s + "пав. #{params[:pavilion]}, " unless params[:pavilion].eql?('')
      s.gsub(/, $/, '')
    end

    it 'должен содержать в себе все параметры объекта с заданным форматированием' do
      address = FactoryGirl.create :address

      params = FactoryGirl.attributes_for :address # чистые атрибуты адреса
      params[:case] = address.case
      params[:other] = address.other
      params[:city] = address.city.name
      params[:street] = address.street.name

      s = format_address params
      address.full_address.should eq(s)

    end

    it 'пустые параметры должен пропускать' do
      address = FactoryGirl.create :address, house: ''

      params = FactoryGirl.attributes_for :address
      params[:case] = address.case
      params[:other] = address.other
      params[:city] = address.city.name
      params[:street] = address.street.name
      params[:house] = ''


      s = format_address params
      address.full_address.should eq(s)
    end

  end

  describe '#by_street' do
    before(:each) do
      @street = FactoryGirl.create :street
      @address = FactoryGirl.create :address, street_id: @street.id
    end
    it 'возвращает массив адресов по улице' do
      Addresses::Address.by_street(@street.id).should eq([@address])
    end
  end

end
