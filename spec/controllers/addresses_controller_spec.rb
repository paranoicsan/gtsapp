# encoding: utf-8
require 'spec_helper'
require 'shared/auth_helper'

describe AddressesController do

  let(:branch) { FactoryGirl.create :branch }
  
  before(:each) do
    authorize_user    
  end
  
  def valid_attributes
    {:branch_id => branch.id}
  end
  
  def create_valid
    FactoryGirl.create :address, valid_attributes
  end

  describe "GET index" do
    it "assigns all addresses as @addresses только авторизованым" do
      address = create_valid
      get :index, valid_attributes
      assigns(:addresses).should eq([address])
    end
  end

  describe "GET show" do
    it "assigns the requested address as @address" do
      address = create_valid
      get :show, :id => address.to_param
      assigns(:address).should eq(address)
    end
  end

  describe "GET new" do
    it "assigns a new address as @address" do
      get :new, valid_attributes
      assigns(:address).should be_a_new(Address)
    end
  end

  describe "GET edit" do
    it "assigns the requested address as @address" do
      address = create_valid
      get :edit, :id => address.to_param
      assigns(:address).should eq(address)
    end
  end

  describe "POST create" do
    describe "with valid params" do

      def post_valid
        params = FactoryGirl.attributes_for :address, branch_id: branch.id
        post :create, {:address => params, :branch_id => branch.id}
      end

      it "creates a new Address" do
        expect {
          post_valid
        }.to change(Address, :count).by(1)
      end

      it "assigns a newly created address as @address только авторизованным" do
        post_valid
        assigns(:address).should be_a(Address)
        #noinspection RubyResolve
        assigns(:address).should be_persisted
      end

      it "после создания переходит на страницу филиала" do
        post_valid
        response.should redirect_to(branch)
      end
    end

    describe "with invalid params" do

      def post_invalid
        params = FactoryGirl.attributes_for :address, branch_id: nil
        post :create, {:address => params, :branch_id => branch.id}
      end

      it "assigns a newly created but unsaved address as @address" do
        Address.any_instance.stub(:save).and_return(false)
        post_invalid
        assigns(:address).should be_a_new(Address)
      end

      it "re-renders the 'new' template" do
        Address.any_instance.stub(:save).and_return(false)
        post_invalid
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    let(:address) { create_valid }

    describe "with valid params" do

      def put_valid
        put :update, :id => address.to_param, :address => valid_attributes
      end

      it "updates the requested address" do
        p = HashWithIndifferentAccess.new(these: 'params')
        Address.any_instance.should_receive(:update_attributes).with(p)
        put :update, :id => address.to_param, :address => p
      end

      it "assigns the requested address as @address" do
        put_valid
        assigns(:address).should eq(address)
        assigns(:branch).should eq(branch)
      end

      it "redirects to the branch" do
        put_valid
        response.should redirect_to(branch)
      end
    end

    describe "with invalid params" do

      def put_invalid
        put :update, :id => address.to_param, :address => {}
      end

      it "assigns the address as @address" do
        Address.any_instance.stub(:save).and_return(false)
        put_invalid
        assigns(:address).should eq(address)
      end

      it "re-renders the 'edit' template" do
        Address.any_instance.stub(:save).and_return(false)
        put_invalid
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested address" do
      address = create_valid
      expect {
        delete :destroy, :id => address.to_param
      }.to change(Address, :count).by(-1)
    end

    it "redirects to страница филиала" do
      address = create_valid
      delete :destroy, :id => address.to_param
      response.should redirect_to(branch_url(branch))
    end
  end

end
