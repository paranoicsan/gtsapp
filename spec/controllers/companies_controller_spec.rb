# encoding: utf-8
require 'spec_helper'
require 'shared/auth_helper'

describe CompaniesController do

  RSpec.configure do |c|
    c.include AuthHelper
  end

  before(:each) do
    controller.stub(:require_user).and_return(true) # подмена авторизованного пользователя
    controller.stub(:require_admin).and_return(true) # подмена прав администратора
    @user = mock(User)
    @user.stub(:is_admin?).with(no_args).and_return(true) # подмена, что пользователь является администратором
    controller.stub(:current_user).and_return(@user) # подмена текущего пользователя
  end

  # This should return the minimal set of attributes required to create a valid
  # Company. As you add validations to Company, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        :title => 'rspec_company',
        :date_added => Date::today
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CompaniesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "Подготовка значений рубрикатора" do
    before(:each) do
      @params = {}
    end
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

  describe "GET index" do
    it "assigns all companies as @companies" do
      company = Company.create! valid_attributes
      get :index, {}, valid_session
      assigns(:companies).should eq([company])
    end
  end

  describe "GET show" do
    it "assigns the requested company as @company" do
      company = Company.create! valid_attributes
      get :show, {:id => company.to_param}, valid_session
      assigns(:company).should eq(company)
    end
  end

  describe "GET new" do
    it "assigns a new company as @company" do
      get :new, {}, valid_session
      assigns(:company).should be_a_new(Company)
    end
  end

  describe "GET edit" do
    it "assigns the requested company as @company" do
      company = Company.create! valid_attributes
      get :edit, {:id => company.to_param}, valid_session
      assigns(:company).should eq(company)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Company" do
        expect {
          post :create, {:company => valid_attributes}, valid_session
        }.to change(Company, :count).by(1)
      end

      it "создается со статусом АКТИВНА для админа и оператора" do
        status = CompanyStatus.create!  :name => "Активна"
        post :create, {:company => valid_attributes}, valid_session
        assigns(:company).company_status == status
      end

      it "создается со статусом НА РАССМОТРЕНИИ для агента" do

      end

      it "assigns a newly created company as @company" do
        post :create, {:company => valid_attributes}, valid_session
        assigns(:company).should be_a(Company)
        #noinspection RubyResolve
        assigns(:company).should be_persisted
      end

      it "redirects to the created company" do
        post :create, {:company => valid_attributes}, valid_session
        response.should redirect_to(Company.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved company as @company" do
        # Trigger the behavior that occurs when invalid params are submitted
        Company.any_instance.stub(:save).and_return(false)
        post :create, {:company => {}}, valid_session
        assigns(:company).should be_a_new(Company)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Company.any_instance.stub(:save).and_return(false)
        post :create, {:company => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested company" do
        company = Company.create! valid_attributes
        # Assuming there are no other companies in the database, this
        # specifies that the Company created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Company.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params', :rubricator.to_s => 0})
        put :update, {:id => company.to_param, :company => {:these => 'params'}}, valid_session
      end

      it "assigns the requested company as @company" do
        company = Company.create! valid_attributes
        put :update, {:id => company.to_param, :company => valid_attributes}, valid_session
        assigns(:company).should eq(company)
      end

      it "redirects to the company" do
        company = Company.create! valid_attributes
        put :update, {:id => company.to_param, :company => valid_attributes}, valid_session
        response.should redirect_to(company)
      end
    end

    describe "with invalid params" do
      it "assigns the company as @company" do
        company = Company.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Company.any_instance.stub(:save).and_return(false)
        put :update, {:id => company.to_param, :company => {}}, valid_session
        assigns(:company).should eq(company)
      end

      it "re-renders the 'edit' template" do
        company = Company.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Company.any_instance.stub(:save).and_return(false)
        put :update, {:id => company.to_param, :company => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested company" do
      company = Company.create! valid_attributes
      expect {
        delete :destroy, {:id => company.to_param}, valid_session
      }.to change(Company, :count).by(-1)
    end

    it "redirects to the companies list" do
      company = Company.create! valid_attributes
      delete :destroy, {:id => company.to_param}, valid_session
      #noinspection RubyResolve
      response.should redirect_to(companies_url)
    end
  end

end
