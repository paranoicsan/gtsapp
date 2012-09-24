# encoding: utf-8
require 'spec_helper'

describe StreetsController do

  before(:each) do
    authorize_user
  end

  # This should return the minimal set of attributes required to create a valid
  # Street. As you add validations to Street, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  describe "GET index" do
    it "assigns all streets as @streets" do
      street = Street.create! valid_attributes
      get :index, {}
      assigns(:streets).should eq([street])
    end
  end

  describe "GET show" do
    it "assigns the requested street as @street" do
      street = Street.create! valid_attributes
      get :show, {:id => street.to_param}
      assigns(:street).should eq(street)
    end
  end

  describe "GET new" do
    it "assigns a new street as @street" do
      make_user_system
      get :new, {}
      assigns(:street).should be_a_new(Street)
    end
  end

  describe "GET edit" do
    it "assigns the requested street as @street" do
      make_user_system
      street = Street.create! valid_attributes
      get :edit, {:id => street.to_param}
      assigns(:street).should eq(street)
    end
  end

  describe "POST create" do

    before(:each) do
      make_user_system
    end

    describe "with valid params" do
      it "creates a new Street" do
        expect {
          post :create, {:street => valid_attributes}
        }.to change(Street, :count).by(1)
      end

      it "assigns a newly created street as @street" do
        post :create, {:street => valid_attributes}
        assigns(:street).should be_a(Street)
        #noinspection RubyResolve
        assigns(:street).should be_persisted
      end

      it "redirects to the created street" do
        post :create, {:street => valid_attributes}
        response.should redirect_to(Street.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved street as @street" do
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        post :create, {:street => {}}
        assigns(:street).should be_a_new(Street)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        post :create, {:street => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      make_user_system
    end

    describe "with valid params" do
      it "updates the requested street" do
        street = Street.create! valid_attributes
        # Assuming there are no other streets in the database, this
        # specifies that the Street created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Street.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => street.to_param, :street => {:these => 'params'}}
      end

      it "assigns the requested street as @street" do
        street = Street.create! valid_attributes
        put :update, {:id => street.to_param, :street => valid_attributes}
        assigns(:street).should eq(street)
      end

      it "redirects to the street" do
        street = Street.create! valid_attributes
        put :update, {:id => street.to_param, :street => valid_attributes}
        response.should redirect_to(street)
      end
    end

    describe "with invalid params" do
      it "assigns the street as @street" do
        street = Street.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        put :update, {:id => street.to_param, :street => {}}
        assigns(:street).should eq(street)
      end

      it "re-renders the 'edit' template" do
        street = Street.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        put :update, {:id => street.to_param, :street => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      make_user_system
    end

    it "destroys the requested street" do
      street = Street.create! valid_attributes
      expect {
        delete :destroy, {:id => street.to_param}
      }.to change(Street, :count).by(-1)
    end

    it "redirects to the streets list" do
      street = Street.create! valid_attributes
      delete :destroy, {:id => street.to_param}
      #noinspection RubyResolve
      response.should redirect_to(streets_url)
    end
  end

  describe "#streets_by_city" do
    before(:each) do
      @city = FactoryGirl.create :city
      @street = FactoryGirl.create :street, city_id: @city.id
    end
    it "возвращает пустой набор @streets_by_city, если не указан город" do
      get :streets_by_city, city_id: nil
      assigns(:streets_by_city).should eq([])
    end
    it "возвращает набор улиц для указанного города" do
      get :streets_by_city, city_id: @city.id
      assigns(:streets_by_city).should eq([@street])
    end
  end
end
