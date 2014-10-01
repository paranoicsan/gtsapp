require 'spec_helper'

describe Address::DistrictsController do

  def valid_attributes
    FactoryGirl.attributes_for :district
  end

  describe 'GET index' do

    login_as_user

    it 'assigns all districts as @districts' do
      district = FactoryGirl.create :district
      get :index
      assigns(:districts).should eq([district])
    end
  end

  describe 'GET show' do

    login_as_user

    it 'assigns the requested district as @district' do
      district = FactoryGirl.create :district
      get :show, {:id => district.to_param}
      assigns(:district).should eq(district)
    end
  end

  describe 'GET new' do

    login_as_operator

    it 'assigns a new district as @district' do
      get :new, {}
      assigns(:district).should be_a_new(Addresses::District)
    end
  end

  describe 'GET edit' do

    login_as_operator

    it 'assigns the requested district as @district' do
      district = FactoryGirl.create :district
      get :edit, {:id => district.to_param}
      assigns(:district).should eq(district)
    end
  end

  describe 'POST create' do

    login_as_operator

    describe 'with valid params' do
      it 'creates a new District' do
        expect {
          post :create, {:district => valid_attributes}
        }.to change(Addresses::District, :count).by(1)
      end

      it 'assigns a newly created district as @district' do
        post :create, {:district => valid_attributes}
        assigns(:district).should be_a(Addresses::District)
        assigns(:district).should be_persisted
      end

      it 'redirects to the created district' do
        post :create, {:district => valid_attributes}
        response.should redirect_to(district_path(Addresses::District.last))
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved district as @district' do
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::District.any_instance.stub(:save).and_return(false)
        post :create, {:district => {}}
        assigns(:district).should be_a_new(Addresses::District)
      end

      it 're-renders the new template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::District.any_instance.stub(:save).and_return(false)
        post :create, {:district => {}}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do

    login_as_operator

    describe 'with valid params' do
      it 'updates the requested district' do
        district = FactoryGirl.create :district
        Addresses::District.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => district.to_param, :district => {:these => 'params'}}
      end

      it 'assigns the requested district as @district' do
        district = FactoryGirl.create :district
        put :update, {:id => district.to_param, :district => valid_attributes}
        assigns(:district).should eq(district)
      end

      it 'redirects to the district' do
        district = FactoryGirl.create :district
        put :update, {:id => district.to_param, :district => valid_attributes}
        response.should redirect_to(district_path(district))
      end
    end

    describe 'with invalid params' do
      it 'assigns the district as @district' do
        district = FactoryGirl.create :district
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::District.any_instance.stub(:save).and_return(false)
        put :update, {:id => district.to_param, :district => {}}
        assigns(:district).should eq(district)
      end

      it 're-renders the edit template' do
        district = FactoryGirl.create :district
        # Trigger the behavior that occurs when invalid params are submitted
        Addresses::District.any_instance.stub(:save).and_return(false)
        put :update, {:id => district.to_param, :district => {}}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do

    login_as_operator

    it 'destroys the requested district' do
      district = FactoryGirl.create :district
      expect {
        delete :destroy, {:id => district.to_param}
      }.to change(Addresses::District, :count).by(-1)
    end

    it 'redirects to the districts list' do
      district = FactoryGirl.create :district
      delete :destroy, {:id => district.to_param}
      #noinspection RubyResolve
      response.should redirect_to(districts_url)
    end
  end

end
