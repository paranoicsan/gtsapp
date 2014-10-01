require 'spec_helper'

describe CitiesController do

  def valid_attributes
    FactoryGirl.attributes_for :city
  end

  describe 'GET index' do

    login_as_user

    it 'assigns all cities as @cities' do
      city = FactoryGirl.create :city
      get :index
      assigns(:cities).should eq([city])
    end
  end

  describe 'GET show' do

    login_as_user

    it 'assigns the requested city as @city' do
      city = FactoryGirl.create :city
      get :show, {:id => city.to_param}
      assigns(:city).should eq(city)
    end
  end

  describe 'GET new' do

    login_as_operator

    it 'assigns a new city as @city' do
      get :new
      assigns(:city).should be_a_new(Addresses::City)
    end
  end

  describe 'GET edit' do

    login_as_operator

    it 'assigns the requested city as @city' do
      city = FactoryGirl.create :city
      get :edit, {:id => city.to_param}
      assigns(:city).should eq(city)
    end
  end

  describe 'POST create' do

    login_as_operator

    describe 'with valid params' do
      it 'creates a new Addresses::City' do
        expect {
          post :create, {:city => valid_attributes}
        }.to change(Addresses::City, :count).by(1)
      end

      it 'assigns a newly created city as @city' do
        post :create, {:city => valid_attributes}
        assigns(:city).should be_a(Addresses::City)
        #noinspection RubyResolve
        assigns(:city).should be_persisted
      end

      it 'redirects to the created city' do
        post :create, {:city => valid_attributes}
        response.should redirect_to( city_path(Addresses::City.last) )
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved city as @city' do
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::City.any_instance.stub(:save).and_return(false)
        post :create, {:city => {}}
        assigns(:city).should be_a_new(Addresses::City)
      end

      it 're-renders the new template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::City.any_instance.stub(:save).and_return(false)
        post :create, {:city => {}}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do

    login_as_operator

    describe 'with valid params' do
      it 'updates the requested city' do
        city = Addresses::City.create! valid_attributes
        # Assuming there are no other cities in the database, this
        # specifies that the Addresses::City created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Addresses::City.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => city.to_param, :city => {:these => 'params'}}
      end

      it 'assigns the requested city as @city' do
        city = Addresses::City.create! valid_attributes
        put :update, {:id => city.to_param, :city => valid_attributes}
        assigns(:city).should eq(city)
      end

      it 'redirects to the city' do
        city = Addresses::City.create! valid_attributes
        put :update, {:id => city.to_param, :city => valid_attributes}
        response.should redirect_to(city_path(city))
      end
    end

    describe 'with invalid params' do
      it 'assigns the city as @city' do
        city = Addresses::City.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::City.any_instance.stub(:save).and_return(false)
        put :update, {:id => city.to_param, :city => {}}
        assigns(:city).should eq(city)
      end

      it 're-renders the edit template' do
        city = Addresses::City.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::City.any_instance.stub(:save).and_return(false)
        put :update, {:id => city.to_param, :city => {}}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do

    login_as_operator

    it 'destroys the requested city' do
      city = Addresses::City.create! valid_attributes
      expect {
        delete :destroy, {:id => city.to_param}
      }.to change(Addresses::City, :count).by(-1)
    end

    it 'redirects to the cities list' do
      city = Addresses::City.create! valid_attributes
      delete :destroy, {:id => city.to_param}
      #noinspection RubyResolve
      response.should redirect_to(cities_url)
    end
  end

end
