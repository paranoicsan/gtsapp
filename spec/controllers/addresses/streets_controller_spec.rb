require 'spec_helper'

describe StreetsController do

  before(:each) do
    authorize_user
    @street = FactoryGirl.create :street
  end

  def valid_attributes
    FactoryGirl.attributes_for :street
  end

  describe 'GET index' do
    it 'assigns all streets as @streets' do
      get :index
      assigns(:streets).should eq([@street])
    end
  end

  describe 'GET new' do
    it 'assigns a new street as @street' do
      make_user_system
      get :new, {}
      assigns(:street).should be_a_new(Street)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested street as @street' do
      make_user_system
      get :edit, {:id => @street.to_param}
      assigns(:street).should eq(@street)
    end
  end

  describe 'POST create' do

    before(:each) do
      make_user_system
    end

    describe 'with valid params' do
      it 'creates a new Street' do
        expect {
          post :create, :street => valid_attributes
        }.to change(Street, :count).by(1)
      end

      it 'assigns a newly created street as @street' do
        post :create, {:street => valid_attributes}
        assigns(:street).should be_a(Street)
        #noinspection RubyResolve
        assigns(:street).should be_persisted
      end

      it 'направляет на список улиц' do
        post :create, {:street => valid_attributes}
        response.should redirect_to(streets_path)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved street as @street' do
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        post :create, {:street => {}}
        assigns(:street).should be_a_new(Street)
      end
      it 're-renders the new template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        post :create, {:street => {}}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do

    before(:each) do
      make_user_system
    end

    describe 'with valid params' do
      it 'updates the requested street' do
        Street.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => @street.to_param, :street => {:these => 'params'}}
      end

      it 'assigns the requested street as @street' do
        put :update, {:id => @street.to_param, :street => valid_attributes}
        assigns(:street).should eq(@street)
      end

      it 'направляет на список улиц' do
        put :update, {:id => @street.to_param, :street => valid_attributes}
        response.should redirect_to(streets_path)
      end
    end

    describe 'with invalid params' do
      it 'assigns the street as @street' do
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        put :update, {:id => @street.to_param, :street => {}}
        assigns(:street).should eq(@street)
      end

      it 're-renders the edit template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Street.any_instance.stub(:save).and_return(false)
        put :update, {:id => @street.to_param, :street => {}}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do

    before(:each) do
      make_user_system
    end

    it 'destroys the requested street' do
      expect {
        delete :destroy, {:id => @street.to_param}
      }.to change(Street, :count).by(-1)
    end

    it 'redirects to the streets list' do
      delete :destroy, {:id => @street.to_param}
      #noinspection RubyResolve
      response.should redirect_to(streets_url)
    end
  end

  context 'streets_by_city' do

    before(:each) do
      @city = FactoryGirl.create :city
      @street = FactoryGirl.create :street, city_id: @city.id
    end

    context 'сохраняет параметры формирования отчёта в сессии' do
      it 'сохраняет ключ населённого пункта' do
        get :streets_by_city, city_id: @city.id
        session[:report_params][:city_id].should eq(@city.id)
      end
    end

    describe 'POST streets_by_city' do

      it 'возвращает пустой набор @streets_by_city, если не указан город' do
        get :streets_by_city, city_id: nil
        assigns(:streets_by_city).should eq([])
      end
      it 'возвращает набор улиц для указанного города' do
        get :streets_by_city, city_id: @city.id
        assigns(:streets_by_city).should eq([@street])
      end
    end

    describe 'GET streets_by_city_export' do
      before(:each) do
        get_valid
      end

      def get_valid
        get :streets_by_city, city_id: @city.id
      end

      it 'возвращает сгенерированный PDF' do
        controller.stub(:render)
        controller.should_receive(:send_data)
        get :streets_by_city_export, format: :pdf
      end
      it 'возвращает сгенерированный RTF' do
        controller.stub(:render)
        controller.should_receive(:send_data)
        get :streets_by_city_export, format: :rtf
      end
      it 'возвращает сгенерированный XLS' do
        controller.stub(:render)
        controller.should_receive(:send_data)
        get :streets_by_city_export, format: :xls
      end
    end
  end

end
