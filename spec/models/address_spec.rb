# encoding: utf-8
require 'spec_helper'

describe Address do

  describe "Метод показа полной адресной строки" do

    # @return Все заполненные параметры
    def full_params
      {
          :cabinet => 1,
          :case => 2,
          :city_id => 1,
          :district_id => 1,
          :entrance => 3,
          :house => 4,
          :litera => 5,
          :stage => 2,
          :office => 6,
          :other => "Текстовый ориентир",
          :pavilion => 7,
          :post_index_id => 6,
          :street_id => 4
      }
    end

    # @param [Hash] Набор параметров, для которых формируется строка
    # @return Отформатированную строку по параметрам
    def get_formatted_str(params)

      pi = NIL
      di = NIL
      ci = NIL
      ss = NIL

      pi = PostIndex.find(params[:post_index_id]) if params[:post_index_id]
      ci = City.find(params[:city_id]) if params[:city_id]
      di = District.find(params[:district_id]) if params[:district_id]
      ss = Street.find(params[:street_id]) if params[:street_id]

      s = ""
      s = s + "#{pi.code}, " unless pi.is_a?(NilClass)
      s = s + "#{ci.name}, " unless ci.is_a?(NilClass)
      s = s + "#{di.name}, " unless di.is_a?(NilClass)
      s = s + "#{ss.name} " unless ss.is_a?(NilClass)
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

    # Мок для Почтового индекса
    def prepare_postindex(id)
      @pi_ = mock_model(PostIndex)
      PostIndex.stub(:find).with(id).and_return(@pi_)
      @pi_.stub(:code).with(no_args).and_return("236000")
    end

    def prepare_city(id)
      @ci_ = mock_model(City)
      City.stub(:find).with(id).and_return(@ci_)
      @ci_.stub(:name).with(no_args).and_return("г. Тагил")
    end

    def prepare_district(id)
      @di_ = mock_model(District)
      District.stub(:find).with(id).and_return(@di_)
      @di_.stub(:name).with(no_args).and_return("Центральный")
    end

    def prepare_street(id)
      @ss_ = mock_model(Street)
      Street.stub(:find).with(id).and_return(@ss_)
      @ss_.stub(:name).with(no_args).and_return("ул. Косм. Леонова")
    end

    before(:each) do
      @address = Address.new
      prepare_postindex full_params[:post_index_id]
      prepare_city full_params[:city_id]
      prepare_district full_params[:district_id]
      prepare_street full_params[:street_id]
    end

    it "должен содержать в себе все параметры объекта с заданным форматированием" do
      params = full_params

      @address.update_attributes! params
      @address.district = @di_
      @address.city = @ci_
      @address.post_index = @pi_
      @address.street = @ss_

      s = get_formatted_str params
      assert @address.full_address == s, "Форматрование адреса не работает"
    end

    it "пустые параметры должен пропускать" do
      params = {
          :city_id => 1,
          :district_id => 1,
          :post_index_id => 6,
          :street_id => 4
      }

      @address.update_attributes! params
      @address.district = @di_
      @address.city = @ci_
      @address.post_index = @pi_
      @address.street = @ss_

      s = get_formatted_str params
      assert @address.full_address == s, "Форматрование адреса не работает"
    end

  end

end
