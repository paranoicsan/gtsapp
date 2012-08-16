# encoding: utf-8
require 'spec_helper'
require 'shared/auth_helper'

describe CompaniesController do

  RSpec.configure do |c|
    c.include AuthHelper
  end

  before(:each) do
    authorize_user
    make_user_admin

    @user = FactoryGirl.create :user_admin
    controller.stub(:current_user).and_return(@user) # подмена текущего пользователя
  end

  def valid_attributes
    res = FactoryGirl.attributes_for :company

    res[:author_user_id] = @user.id
    res[:editor_user_id] = @user.id
    res
  end

  describe ".prepare_rubricator" do
    before(:each) do
      @params = {}
    end
    context "Подготовка значений рубрикатора" do
      it "должен возвращать сумму для полного рубрикатора" do
        @params[0] = 1
        @params[1] = 2
        assert CompaniesController.prepare_rubricator(@params) == 3, "Значения для рубрикатора не суммируются"
      end
      it "должен возвращать отдельные значения для социального рубрикатора " do
        @params[0] = 1
        assert CompaniesController.prepare_rubricator(@params) == 1, "Неверное значение для социального рубрикатора"
      end
      it "должен возвращать отдельные значения для коммерческого рубрикатора " do
        @params[1] = 2
        assert CompaniesController.prepare_rubricator(@params) == 2, "Неверное значение для коммерческого рубрикатора"
      end
     end
  end

  describe "GET request_delete_reason" do

    let(:company) { FactoryGirl.create :company }

    def request_valid
      get :request_delete_reason, id: company.to_param
    end

    it "присваивает компанию @company" do
      request_valid
      assigns(:company).should eq(company)
    end
    it "генерирует шаблон для ввода причины удаления" do
      request_valid
      response.should be_success
      response.should render_template :request_delete_reason
    end
  end

  describe "GET unqueue_for_delete" do

    let(:company) { FactoryGirl.create :company_queued_for_delete }

    before(:each) do
      FactoryGirl.create :company_status_active
      FactoryGirl.create :company_status_suspended
    end

    def get_valid
      get :unqueue_for_delete, id: company.to_param, format: 'js'
    end

    it "присваивает компанию @company" do
      get_valid
      assigns(:company).should eq(company)
    end

    context "вызов со страницы компании" do
      it "возвращает JavaScript-ответ для обновления данных на странице" do
        request.env["HTTP_REFERER"] = company_path(company)
        get_valid
        response.should be_success
      end
    end

    context "вызов с любой другой страницы" do
      it "возвращает обратно на страницу сводки" do
        request.env["HTTP_REFERER"] = dashboard_url
        get_valid
        response.should redirect_to dashboard_url
      end
    end
  end

  describe "POST queue_for_delete" do


    before(:each) do
      FactoryGirl.create :company_status_on_deletion
    end

    context "компания ставится на удаление" do

      let(:company) { FactoryGirl.create :company }

      context "с верными параметрами" do

        def queue_valid
          params ={
            reason_deleted_on: Faker::Lorem.sentence
          }
          post :queue_for_delete, id: company.to_param, company: params, format: 'js'
        end

        it "присваивает компанию @company" do
          queue_valid
          assigns(:company).should eq(company)
        end

        it "возвращает JavaScript-ответ для обновления данных на странице" do
          queue_valid
          response.should be_success
        end

      end

      context "с не верными параметрами" do
        def queue_invalid
          post :queue_for_delete, id: company.to_param, company: {}, format: 'js'
        end

        it "присваивает компанию @company" do
          queue_invalid
          assigns(:company).should eq(company)
        end

        it "занового генерирует шаблон для ввода причины удаления" do
          queue_invalid
          response.should render_template "re_request_delete_reason"
        end

      end

    end

  end

  describe "GET index" do
    it "assigns all companies as @companies" do
      company = FactoryGirl.create :company
      get :index
      assigns(:companies).should eq([company])
    end
  end

  describe "GET show" do
    it "assigns the requested company as @company" do
      company = FactoryGirl.create :company
      get :show, :id => company.to_param
      assigns(:company).should eq(company)
    end
  end

  describe "GET new" do
    it "assigns a new company as @company" do
      get :new
      assigns(:company).should be_a_new(Company)
    end
  end

  describe "GET edit" do
    it "assigns the requested company as @company" do
      company = FactoryGirl.create :company
      get :edit, {:id => company.to_param}
      assigns(:company).should eq(company)
    end
  end

  describe "POST create" do
    describe "with valid params" do

      def post_valid
        post :create, :company => valid_attributes
      end

      it "creates a new Company" do
        expect {
          post_valid
        }.to change(Company, :count).by(1)
      end

      it "assigns a newly created company as @company" do
        post_valid
        assigns(:company).should be_a(Company)
        #noinspection RubyResolve
        assigns(:company).should be_persisted
      end

      it "redirects to the created company" do
        post_valid
        response.should redirect_to(Company.last)
      end
    end

    describe "with invalid params" do

      def post_invalid
        post :create, :company => @attrs
      end

      before(:each) do
        @attrs = FactoryGirl.attributes_for(:company, title: nil)
      end

      it "assigns a newly created but unsaved company as @company" do
        # Trigger the behavior that occurs when invalid params are submitted
        post_invalid
        assigns(:company).should be_a_new(Company)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        post_invalid
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      @company = FactoryGirl.create :company, valid_attributes
    end

    describe "with valid params" do

      def put_valid
        put :update, :id => @company.to_param, :company => valid_attributes
      end

      it "updates the requested company" do
        p = HashWithIndifferentAccess.new(
            these: 'params',
            rubricator: 0,
            editor_user_id: @user.id
        )
        Company.any_instance.should_receive(:update_attributes).with(p)
        put :update, :id => @company.to_param, :company => p
      end

      it "assigns the requested company as @company" do
        put_valid
        assigns(:company).should eq(@company)
      end

      it "redirects to the company" do
        put_valid
        response.should redirect_to(@company)
      end
    end

    describe "with invalid params" do

      def put_invalid
        put :update, :id => @company.to_param, :company => {}
      end

      it "assigns the company as @company" do
        # Trigger the behavior that occurs when invalid params are submitted
        Company.any_instance.stub(:save).and_return(false)
        put_invalid
        assigns(:company).should eq(@company)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Company.any_instance.stub(:save).and_return(false)
        put_invalid
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      @company = FactoryGirl.create :company, valid_attributes
    end

    def delete_destroy
      delete :destroy, :id => @company.to_param
    end

    it "destroys the requested company" do
      expect {
        delete_destroy
      }.to change(Company, :count).by(-1)
    end

    it "redirects to the companies list" do
      delete_destroy
      #noinspection RubyResolve
      response.should redirect_to(companies_url)
    end
  end

end
