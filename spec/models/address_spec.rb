# encoding: utf-8
require 'spec_helper'

describe Address do

  it "Фабрика корректна" do
    #noinspection RubyResolve
    create(:address).should be_valid
  end

  it "Не может быть создан без филиала" do
    #noinspection RubyResolve
    build(:address, branch: nil).should_not be_valid
  end

  describe ".full_address возвращает отформатированную строку полного адреса" do

    # @param [Hash] Набор параметров, для которых формируется строка
    # @return Отформатированную строку по параметрам
    def format_address(params)

      s = ""
      #s = "#{s}, #{params[:post_index]}, " unless params[:post_index].eql?("")
      s = "#{params[:city]}, " unless params[:city].eql?("")
      #s = "#{s}, #{params[:district]}, " unless params[:district].eql?("")
      s = "#{s}#{params[:street]} " unless params[:street].eql?("")

      s = s + "д. #{params[:house]}, " unless params[:house].eql?("")
      s = s + "каб. #{params[:cabinet]}, " unless params[:cabinet].eql?("")
      s = s + "корпус #{params[:case]}, " unless params[:case].eql?("")
      s = s + "подъезд #{params[:entrance]}, " unless params[:entrance].eql?("")
      s = s + "литера #{params[:litera]}, " unless params[:litera].eql?("")
      s = s + "этаж #{params[:stage]}, " unless params[:stage].eql?("")
      s = s + "офис #{params[:office]}, " unless params[:office].eql?("")
      s = s + "др. #{params[:other]}, " unless params[:other].eql?("")
      s = s + "пав. #{params[:pavilion]}, " unless params[:pavilion].eql?("")
      s.gsub(/, $/, "")
    end

    it "должен содержать в себе все параметры объекта с заданным форматированием" do
      address = create :address

      params = attributes_for :address # чистые атрибуты адреса
      params[:other] = address.other
      params[:city] = address.city.name
      params[:street] = address.street.name

      s = format_address params
      address.full_address.should eq(s)

    end

    it "пустые параметры должен пропускать" do
      address = create :address_wout_city

      params = attributes_for :address_wout_city # чистые атрибуты адреса
      params[:other] = address.other
      params[:city] = ""
      params[:street] = address.street.name

      s = format_address params
      address.full_address.should eq(s)
    end

  end

end
