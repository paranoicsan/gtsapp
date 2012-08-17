#encoding: utf-8
require 'spec_helper'
require 'shared/auth_helper'

describe ProductTypesController do

  RSpec.configure do |c|
    c.include AuthHelper
  end

  before(:each) do
    make_user_admin
  end

  # This should return the minimal set of attributes required to create a valid
  # ProductType. As you add validations to ProductType, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProductTypesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all product_types as @product_types" do
      product = ProductType.create! valid_attributes
      get :index, {}, valid_session
      assigns(:producttypes).should eq([product])
    end
  end

  describe "GET new" do
    it "assigns a new producttype as @producttype" do
      get :new, {}, valid_session
      assigns(:producttype).should be_a_new(ProductType)
    end
  end

  describe "GET edit" do
    it "assigns the requested producttype as @producttype" do
      product = ProductType.create! valid_attributes
      get :edit, {:id => product.to_param}, valid_session
      assigns(:producttype).should eq(product)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ProductType" do
        expect {
          post :create, {:producttype => valid_attributes}, valid_session
        }.to change(ProductType, :count).by(1)
      end

      it "assigns a newly created producttype as @producttype" do
        post :create, {:producttype => valid_attributes}, valid_session
        assigns(:producttype).should be_a(ProductType)
        #noinspection RubyResolve
        assigns(:producttype).should be_persisted
      end

      it "направляет на список типов продуктов" do
        post :create, {:producttype => valid_attributes}, valid_session
        #noinspection RubyResolve
        response.should redirect_to(product_types_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved producttype as @producttype" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProductType.any_instance.stub(:save).and_return(false)
        post :create, {:producttype => {}}, valid_session
        assigns(:producttype).should be_a_new(ProductType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProductType.any_instance.stub(:save).and_return(false)
        post :create, {:producttype => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested producttype" do
        product = ProductType.create! valid_attributes
        # Assuming there are no other product_types in the database, this
        # specifies that the ProductType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ProductType.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => product.to_param, :producttype => {:these => 'params'}}, valid_session
      end

      it "assigns the requested producttype as @producttype" do
        product = ProductType.create! valid_attributes
        put :update, {:id => product.to_param, :producttype => valid_attributes}, valid_session
        assigns(:producttype).should eq(product)
      end

      it "направляет на список продуктов" do
        product = ProductType.create! valid_attributes
        put :update, {:id => product.to_param, :producttype => valid_attributes}, valid_session
        #noinspection RubyResolve
        response.should redirect_to(product_types_url)
      end
    end

    describe "with invalid params" do
      it "assigns the producttype as @producttype" do
        product = ProductType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProductType.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :producttype => {}}, valid_session
        assigns(:producttype).should eq(product)
      end

      it "re-renders the 'edit' template" do
        product = ProductType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProductType.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :producttype => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested producttype" do
      product = ProductType.create! valid_attributes
      expect {
        delete :destroy, {:id => product.to_param}, valid_session
      }.to change(ProductType, :count).by(-1)
    end

    it "redirects to the product_types list" do
      product = ProductType.create! valid_attributes
      delete :destroy, {:id => product.to_param}, valid_session
      #noinspection RubyResolve
      response.should redirect_to(product_types_url)
    end
  end

end
