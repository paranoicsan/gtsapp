require 'spec_helper'

describe DistrictsController do

  before(:each) do
    authorize_user
  end

  def valid_attributes
    {}
  end
  
  def valid_session
    {}
  end

  describe 'GET index' do
    it 'assigns all districts as @districts' do
      district = District.create! valid_attributes
      get :index, {}, valid_session
      assigns(:districts).should eq([district])
    end
  end

  describe 'GET show' do
    it 'assigns the requested district as @district' do
      district = District.create! valid_attributes
      get :show, {:id => district.to_param}, valid_session
      assigns(:district).should eq(district)
    end
  end

  describe 'GET new' do
    it 'assigns a new district as @district' do
      make_user_operator
      get :new, {}, valid_session
      assigns(:district).should be_a_new(District)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested district as @district' do
      make_user_operator
      district = District.create! valid_attributes
      get :edit, {:id => district.to_param}, valid_session
      assigns(:district).should eq(district)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new District' do
        make_user_operator
        expect {
          post :create, {:district => valid_attributes}, valid_session
        }.to change(District, :count).by(1)
      end

      it 'assigns a newly created district as @district' do
        make_user_operator
        post :create, {:district => valid_attributes}, valid_session
        assigns(:district).should be_a(District)
        #noinspection RubyResolve
        assigns(:district).should be_persisted
      end

      it 'redirects to the created district' do
        make_user_operator
        post :create, {:district => valid_attributes}, valid_session
        response.should redirect_to(District.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved district as @district' do
        make_user_operator
        # Trigger the behavior that occurs when invalid params are submitted
        District.any_instance.stub(:save).and_return(false)
        post :create, {:district => {}}, valid_session
        assigns(:district).should be_a_new(District)
      end

      it 're-renders the new template' do
        make_user_operator
        # Trigger the behavior that occurs when invalid params are submitted
        District.any_instance.stub(:save).and_return(false)
        post :create, {:district => {}}, valid_session
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested district' do
        make_user_operator
        district = District.create! valid_attributes
        # Assuming there are no other districts in the database, this
        # specifies that the District created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        District.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => district.to_param, :district => {:these => 'params'}}, valid_session
      end

      it 'assigns the requested district as @district' do
        make_user_operator
        district = District.create! valid_attributes
        put :update, {:id => district.to_param, :district => valid_attributes}, valid_session
        assigns(:district).should eq(district)
      end

      it 'redirects to the district' do
        make_user_operator
        district = District.create! valid_attributes
        put :update, {:id => district.to_param, :district => valid_attributes}, valid_session
        response.should redirect_to(district)
      end
    end

    describe 'with invalid params' do
      it 'assigns the district as @district' do
        make_user_operator
        district = District.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        District.any_instance.stub(:save).and_return(false)
        put :update, {:id => district.to_param, :district => {}}, valid_session
        assigns(:district).should eq(district)
      end

      it 're-renders the edit template' do
        make_user_operator
        district = District.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        District.any_instance.stub(:save).and_return(false)
        put :update, {:id => district.to_param, :district => {}}, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested district' do
      make_user_operator
      district = District.create! valid_attributes
      expect {
        delete :destroy, {:id => district.to_param}, valid_session
      }.to change(District, :count).by(-1)
    end

    it 'redirects to the districts list' do
      make_user_operator
      district = District.create! valid_attributes
      delete :destroy, {:id => district.to_param}, valid_session
      #noinspection RubyResolve
      response.should redirect_to(districts_url)
    end
  end

end
