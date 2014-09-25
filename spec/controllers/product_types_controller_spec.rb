#encoding: utf-8
require 'spec_helper'

describe ProductTypesController do

  before(:each) do
    make_user_admin
  end

  # This should return the minimal set of attributes required to create a valid
  # Type. As you add validations to Type, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  describe "GET index" do
    it "assigns all product_types as @product_types" do
      product = Type.create! valid_attributes
      get :index, {}
      assigns(:product_types).should eq([product])
    end
  end

  describe "GET new" do
    it "assigns a new producttype as @producttype" do
      get :new, {}
      assigns(:product_type).should be_a_new(Type)
    end
  end

  describe "GET edit" do
    it "assigns the requested producttype as @producttype" do
      product = Type.create! valid_attributes
      get :edit, {:id => product.to_param}
      assigns(:product_type).should eq(product)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Type" do
        expect {
          post :create, {:product_type => valid_attributes}
        }.to change(Type, :count).by(1)
      end

      it "assigns a newly created producttype as @producttype" do
        post :create, {:product_type => valid_attributes}
        assigns(:product_type).should be_a(Type)
        #noinspection RubyResolve
        assigns(:product_type).should be_persisted
      end

      it "направляет на список типов продуктов" do
        post :create, {:product_type => valid_attributes}
        #noinspection RubyResolve
        response.should redirect_to(product_types_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved producttype as @producttype" do
        # Trigger the behavior that occurs when invalid params are submitted
        Type.any_instance.stub(:save).and_return(false)
        post :create, {:product_type => {}}
        assigns(:product_type).should be_a_new(Type)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Type.any_instance.stub(:save).and_return(false)
        post :create, {:product_type => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested producttype" do
        product = Type.create! valid_attributes
        # Assuming there are no other product_types in the database, this
        # specifies that the Type created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Type.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => product.to_param, :product_type => {:these => 'params'}}
      end

      it "assigns the requested producttype as @producttype" do
        product = Type.create! valid_attributes
        put :update, {:id => product.to_param, :product_type => valid_attributes}
        assigns(:product_type).should eq(product)
      end

      it "направляет на список продуктов" do
        product = Type.create! valid_attributes
        put :update, {:id => product.to_param, :product_type => valid_attributes}
        #noinspection RubyResolve
        response.should redirect_to(product_types_url)
      end
    end

    describe "with invalid params" do
      it "assigns the producttype as @producttype" do
        product = Type.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Type.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product_type => {}}
        assigns(:product_type).should eq(product)
      end

      it "re-renders the 'edit' template" do
        product = Type.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Type.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product_type => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested producttype" do
      product = Type.create! valid_attributes
      expect {
        delete :destroy, {:id => product.to_param}
      }.to change(Type, :count).by(-1)
    end

    it "redirects to the product_types list" do
      product = Type.create! valid_attributes
      delete :destroy, {:id => product.to_param}
      #noinspection RubyResolve
      response.should redirect_to(product_types_url)
    end
  end

end
