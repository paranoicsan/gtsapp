# encoding: utf-8
require "spec_helper"

describe CitiesController do

  RSpec.configure do |c|
    c.include AuthHelper
  end

  before(:each) do
    authorize_user
  end

  # This should return the minimal set of attributes required to create a valid
  # City. As you add validations to City, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CitiesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all cities as @cities" do
      city = City.create! valid_attributes
      get :index, {}, valid_session
      assigns(:cities).should eq([city])
    end
  end

  describe "GET show" do
    it "assigns the requested city as @city" do
      city = City.create! valid_attributes
      get :show, {:id => city.to_param}, valid_session
      assigns(:city).should eq(city)
    end
  end

  describe "GET new" do
    it "assigns a new city as @city" do
      make_user_operator
      get :new, {}, valid_session
      assigns(:city).should be_a_new(City)
    end
  end

  describe "GET edit" do
    it "assigns the requested city as @city" do
      make_user_operator
      city = City.create! valid_attributes
      get :edit, {:id => city.to_param}, valid_session
      assigns(:city).should eq(city)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new City" do
        make_user_operator
        expect {
          post :create, {:city => valid_attributes}, valid_session
        }.to change(City, :count).by(1)
      end

      it "assigns a newly created city as @city" do
        make_user_operator
        post :create, {:city => valid_attributes}, valid_session
        assigns(:city).should be_a(City)
        #noinspection RubyResolve
        assigns(:city).should be_persisted
      end

      it "redirects to the created city" do
        make_user_operator
        post :create, {:city => valid_attributes}, valid_session
        response.should redirect_to(City.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved city as @city" do
        make_user_operator
        # Trigger the behavior that occurs when invalid params are submitted
        City.any_instance.stub(:save).and_return(false)
        post :create, {:city => {}}, valid_session
        assigns(:city).should be_a_new(City)
      end

      it "re-renders the 'new' template" do
        make_user_operator
        # Trigger the behavior that occurs when invalid params are submitted
        City.any_instance.stub(:save).and_return(false)
        post :create, {:city => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested city" do
        make_user_operator
        city = City.create! valid_attributes
        # Assuming there are no other cities in the database, this
        # specifies that the City created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        City.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => city.to_param, :city => {:these => 'params'}}, valid_session
      end

      it "assigns the requested city as @city" do
        make_user_operator
        city = City.create! valid_attributes
        put :update, {:id => city.to_param, :city => valid_attributes}, valid_session
        assigns(:city).should eq(city)
      end

      it "redirects to the city" do
        make_user_operator
        city = City.create! valid_attributes
        put :update, {:id => city.to_param, :city => valid_attributes}, valid_session
        response.should redirect_to(city)
      end
    end

    describe "with invalid params" do
      it "assigns the city as @city" do
        make_user_operator
        city = City.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        City.any_instance.stub(:save).and_return(false)
        put :update, {:id => city.to_param, :city => {}}, valid_session
        assigns(:city).should eq(city)
      end

      it "re-renders the 'edit' template" do
        make_user_operator
        city = City.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        City.any_instance.stub(:save).and_return(false)
        put :update, {:id => city.to_param, :city => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested city" do
      make_user_operator
      city = City.create! valid_attributes
      expect {
        delete :destroy, {:id => city.to_param}, valid_session
      }.to change(City, :count).by(-1)
    end

    it "redirects to the cities list" do
      make_user_operator
      city = City.create! valid_attributes
      delete :destroy, {:id => city.to_param}, valid_session
      #noinspection RubyResolve
      response.should redirect_to(cities_url)
    end
  end

end
