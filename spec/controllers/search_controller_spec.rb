# Encoding: utf-8
require "spec_helper"
require "faker"

describe SearchController do

  before(:each) do
    authorize_user
  end

  def valid_params_search
    {
      search_email: Faker::Internet.email,
      search_name: Faker::Company.name,
      search_phone: Faker::PhoneNumber.phone_number,
      search_house: 3,
      search_office: 4,
      search_cabinet: 5,
      select_search_city: 90,
      select_search_street: 91
    }
  end

  describe "POST search_company" do
    context "сохраняет параметры поиска в сессии" do

      before(:each) do
        @params = valid_params_search
        post :search_company, @params
      end

      it "сохраняет имя" do
        session[:search_params][:search_name].should eq(@params[:name])
      end
      it "сохраняет электронную почту" do
        session[:search_params][:search_email].should eq(@params[:email])
      end
      it "сохраняет город" do
        session[:search_params][:select_search_city].should eq(@params[:city])
      end
      it "сохраняет улицу" do
        session[:search_params][:select_search_street].should eq(@params[:street])
      end
      it "сохраняет дом" do
        session[:search_params][:search_house].should eq(@params[:house])
      end
      it "сохраняет офис" do
        session[:search_params][:search_office].should eq(@params[:office])
      end
      it "сохраняет кабинет" do
        session[:search_params][:search_cabinet].should eq(@params[:cabinet])
      end
      it "сохраняет телефон" do
        session[:search_params][:search_phone].should eq(@params[:phone])
      end
    end
  end

  describe "GET index" do
    context "после выполненного поиска" do
      before(:each) do
        post :search_company, valid_params_search # выполняем поиск и сохраняем параметры
      end
      it "обнуляет параметры поиска в сессии, если нет параметра возврата" do
        get :index
        session[:search_params].should be_nil
      end
      it "содержит параметры в сессии при возвращении" do
        get :index, back_to: true
        session[:search_params].should_not be_nil
      end
      it "при возвращении повторяет поиск" do
        controller.should_receive(:make_search)
        get :index, back_to: true
      end
    end
  end

end

