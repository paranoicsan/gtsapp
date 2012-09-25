# encoding: utf-8
require 'spec_helper'

describe CompaniesController do

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

      context "с неверными параметрами" do
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

  describe "GET request_attention_reason" do

    let(:company) { FactoryGirl.create :company }

    def request_valid
      get :request_attention_reason, id: company.to_param
    end

    it "присваивает компанию @company" do
      request_valid
      assigns(:company).should eq(company)
    end
    it "генерирует шаблон для ввода причины обращения к администратору" do
      request_valid
      response.should be_success
      response.should render_template :request_attention_reason
    end
  end

  describe "POST request_attention" do

    before(:each) do
      FactoryGirl.create :company_status_need_attention
      @company = FactoryGirl.create :company
    end

    context "с верными параметрами" do
      def post_valid
        params ={
            reason_need_attention_on: Faker::Lorem.sentence
        }
        post :request_attention, id: @company.to_param, company: params, format: 'js'
      end
      it "присваивает компанию как @company" do
        post_valid
        assigns(:company).should eq(@company)
      end
      it "меняет статус компании на Требует внимания" do
        p = HashWithIndifferentAccess.new(
            reason_need_attention_on: Faker::Lorem.sentence,
            company_status: CompanyStatus.need_attention
        )
        Company.any_instance.should_receive(:update_attributes).with(p)
        post :request_attention, id: @company.to_param, company: p, format: 'js'
      end
      it "возвращает JavaScript-ответ для обновления данных на странице" do
        post_valid
        response.should be_success
      end
    end
    context "с неверными параметрами" do
      def post_invalid
        params ={
            reason_need_attention_on: ""
        }
        post :request_attention, id: @company.to_param, company: params, format: 'js'
      end
      it "присваивает компанию как @company" do
        post_invalid
        assigns(:company).should eq(@company)
      end
      it "занового генерирует шаблон для ввода причины обращения" do
        post_invalid
        response.should render_template :re_request_attention_reason
      end
    end
  end

  describe "GET request_improvement_reason" do

    let(:company) { FactoryGirl.create :company }

    def request_valid
      make_user_system
      get :request_improvement_reason, id: company.to_param
    end

    it "присваивает компанию @company" do
      request_valid
      assigns(:company).should eq(company)
    end
    it "генерирует шаблон для ввода причины отправки на доработку" do
      request_valid
      response.should be_success
      response.should render_template :request_improvement_reason
    end
  end

  describe "GET improve" do
    before(:each) do
      @company = FactoryGirl.create :company, reason_need_improvement_on: Faker::Lorem.sentence
      FactoryGirl.create :company_status_second_suspend
      request.env["HTTP_REFERER"] = company_path(@company)
    end
    def get_improve
      get :improve, id: @company.to_param
    end
    it "обнуляет ранее существовавшую причину отправки компании на доработку" do
      get_improve
      Company.find(@company.id).reason_need_improvement_on.should be_nil
    end
    it "отправляет на страницу, с которой выполнялась операция" do
      get_improve
      response.should redirect_to company_path(@company)
    end
  end

  describe "GET archive" do
    before(:each) do
      @company = FactoryGirl.create :company
      FactoryGirl.create :company_status_archived
    end
    it "отправляет на страницу, с которой выполнялась операция" do
      request.env["HTTP_REFERER"] = company_path(@company)
      get :archive, id: @company.id
      response.should redirect_to company_path(@company)
    end
  end

  describe "POST request_improvement" do

    before(:each) do
      make_user_system
      FactoryGirl.create :company_status_need_improvement
      @company = FactoryGirl.create :company
    end

    context "с верными параметрами" do
      def post_valid
        params ={
            reason_need_improvement_on: Faker::Lorem.sentence
        }
        post :request_improvement, id: @company.to_param, company: params, format: 'js'
      end
      it "присваивает компанию как @company" do
        post_valid
        assigns(:company).should eq(@company)
      end
      it "меняет статус компании на Требует доработки" do
        p = HashWithIndifferentAccess.new(
            reason_need_improvement_on: Faker::Lorem.sentence,
            company_status: CompanyStatus.need_improvement
        )
        Company.any_instance.should_receive(:update_attributes).with(p)
        post :request_improvement, id: @company.to_param, company: p, format: 'js'
      end
      it "возвращает JavaScript-ответ для обновления данных на странице" do
        post_valid
        response.should be_success
      end
    end
    context "с неверными параметрами" do
      def post_invalid
        params ={
            reason_need_improvement_on: ""
        }
        post :request_improvement, id: @company.to_param, company: params, format: 'js'
      end
      it "присваивает компанию как @company" do
        post_invalid
        assigns(:company).should eq(@company)
      end
      it "занового генерирует шаблон для ввода причины обращения" do
        post_invalid
        response.should render_template :re_request_improvement_reason
      end
    end
  end

  describe "POST validate_title" do

    let(:company) { FactoryGirl.create :company }

    def post_failed_validation
      post :validate_title, {company_title: company.title}
    end

    def post_success_validation
      post :validate_title, {company_title: Faker::Lorem.words(1).join()}
    end

    it "если провал: присваивает найденную компанию как @company" do
      post_failed_validation
      assigns(:company).should eq(company)
    end
    it "если успех: присваивает nil @company" do
      post_success_validation
      assigns(:company).should eq(nil)
    end
    it "отрабатывает шаблон с сообщением" do
      post_failed_validation
      response.should render_template(:partial => '_validate_title')
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
      it "создаёт запись в истории компании" do
        expect {
          post_valid
        }.to change(CompanyHistory, :count).by(1)
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
      it "создаёт запись в истории компании" do
        expect {
          put_valid
        }.to change(CompanyHistory, :count).by(1)
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

  describe "GET add_rubric" do
    let(:rubric) { FactoryGirl.create :rubric }
    let(:company) { FactoryGirl.create :company, valid_attributes }
    def add_valid
      get :add_rubric, id: company.to_param, rub_id: rubric.id
    end
    it "добавляет рубрику к компании" do
      expect {
        add_valid
      }.to change(CompanyRubric, :count).by(1)
    end
    it "создаёт запись в истории компании" do
      expect {
        add_valid
      }.to change(CompanyHistory, :count).by(1)
    end
  end

  describe "GET delete_rubric" do
    let(:rubric) { FactoryGirl.create :rubric }
    before(:each) do
      @company = FactoryGirl.create :company, valid_attributes
      @company.rubrics << rubric
      @company.save
    end

    def delete_valid
      get :delete_rubric, id: @company.to_param, rub_id: rubric.id
    end
    it "удаляет рубрику из компании" do
      expect {
        delete_valid
      }.to change(CompanyRubric, :count).by(-1)
    end
    it "создаёт запись в истории компании" do
      expect {
        delete_valid
      }.to change(CompanyHistory, :count).by(1)
    end
  end

end
