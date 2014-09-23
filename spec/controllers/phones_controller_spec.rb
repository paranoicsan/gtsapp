#encoding: utf-8
require 'spec_helper'

describe PhonesController do

  
  before(:each) do
    authorize_user
    @user = FactoryGirl.create :user
    controller.stub(:current_user).and_return(@user)
    @branch = FactoryGirl.create :branch
  end

  def valid_attributes
    {branch_id: @branch.id}
  end

  # создание объекта с минимальным набором атрибутов
  def create_valid
    FactoryGirl.create :phone, valid_attributes
  end

  describe 'GET index' do
    it 'assigns all phones as @phones' do
      phone = create_valid
      get :index, valid_attributes
      assigns(:phones).should eq([phone])
    end
  end

  describe 'GET show' do
    it 'assigns the requested phone as @phone' do
      phone = create_valid
      get :show, :id => phone.to_param
      assigns(:phone).should eq(phone)
    end
  end

  describe 'GET new' do
    def get_valid
      get :new, valid_attributes
    end
    it 'assigns a new phone as @phone' do
      get_valid
      assigns(:phone).should be_a_new(Phone)
    end
    it 'выставялет индекс следующий по порядку индекс отображения' do
      pp = FactoryGirl.create :phone, valid_attributes
      get_valid
      assigns(:phone).order_num.should eq(2)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested phone as @phone' do
      phone = create_valid
      get :edit, :id => phone.to_param
      assigns(:phone).should eq(phone)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do

      def post_valid
        params = FactoryGirl.attributes_for :phone, branch_id: @branch.id
        post :create, {:phone => params, :branch_id => @branch.id}
      end

      it 'creates a new Phone' do
        expect {
          post_valid
        }.to change(Phone, :count).by(1)
      end
      it 'assigns a newly created phone as @phone' do
        post_valid
        assigns(:phone).should be_a(Phone)
        #noinspection RubyResolve
        assigns(:phone).should be_persisted
      end
      it 'redirects to the parent Branch' do
        post_valid
        response.should redirect_to(@branch)
      end
      it 'создаёт запись в истории компании' do
        expect {
          post_valid
        }.to change(History, :count).by(1)
      end
    end

    describe 'with invalid params' do

      def post_invalid
        params = FactoryGirl.attributes_for :phone, branch_id: nil
        post :create, {:phone => params, :branch_id => @branch.id}
      end

      it 'assigns a newly created but unsaved phone as @phone' do
        Phone.any_instance.stub(:save).and_return(false)
        post_invalid
        assigns(:phone).should be_a_new(Phone)
      end

      it 're-renders the new template' do
        Phone.any_instance.stub(:save).and_return(false)
        post_invalid
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do

    let(:phone) { create_valid }

    describe 'with valid params' do

      def put_valid
        put :update, :id => phone.to_param, :phone => valid_attributes
      end

      it 'updates the requested phone' do
        p = HashWithIndifferentAccess.new(these: 'params')
        Phone.any_instance.should_receive(:update_attributes).with(p)
        put :update, :id => phone.to_param, :phone => p
      end
      it 'assigns the requested phone as @phone' do
        put_valid
        assigns(:phone).should eq(phone)
      end
      it 'redirects to the branch' do
        put_valid
        response.should redirect_to(@branch)
      end
      it 'создаёт запись в истории компании' do
        expect {
          put_valid
        }.to change(History, :count).by(1)
      end
    end

    describe 'with invalid params' do

      def put_invalid
        put :update, :id => phone.to_param, :phone => {}
      end

      it 'assigns the phone as @phone' do
        Phone.any_instance.stub(:save).and_return(false)
        put_invalid
        assigns(:phone).should eq(phone)
      end

      it 're-renders the edit template' do
        Phone.any_instance.stub(:save).and_return(false)
        put_invalid
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested phone' do
      phone = create_valid
      expect {
        delete :destroy, :id => phone.to_param
      }.to change(Phone, :count).by(-1)
    end
    it 'redirects to the phones list' do
      phone = create_valid
      delete :destroy, :id => phone.to_param
      #noinspection RubyResolve
      response.should redirect_to(branch_url(@branch))
    end
    it 'создаёт запись в истории компании' do
      expect {
        phone = create_valid
        delete :destroy, :id => phone.to_param
      }.to change(History, :count).by(1)
    end
  end

end
