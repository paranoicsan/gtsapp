# Encoding: utf-8
require 'spec_helper'

describe RubricsController do

  before(:each) do
    authorize_user
    make_user_admin # Все методы контроллёра требуют прав админстратора
    @rubric = FactoryGirl.create :rubric
  end

  # This should return the minimal set of attributes required to create a valid
  # Rubric. As you add validations to Rubric, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for :rubric
  end
    
  describe "GET index" do
    it "assigns all rubrics as @rubrics" do
      get :index, {}
      assigns(:rubrics).should eq([@rubric])
    end
  end

  #describe "GET show" do
  #  it "assigns the requested rubric as @rubric" do
  #    get :show, {:id => @rubric.to_param}
  #    assigns(:rubric).should eq(@rubric)
  #  end
  #end

  describe "GET new" do
    it "assigns a new rubric as @rubric" do
      get :new, {}
      assigns(:rubric).should be_a_new(Rubric)
    end
  end

  describe "GET edit" do
    it "assigns the requested rubric as @rubric" do
      get :edit, {:id => @rubric.to_param}
      assigns(:rubric).should eq(@rubric)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Rubric" do
        expect {
          post :create, {:rubric => valid_attributes}
        }.to change(Rubric, :count).by(1)
      end

      it "assigns a newly created rubric as @rubric" do
        post :create, {:rubric => valid_attributes}
        assigns(:rubric).should be_a(Rubric)
        #noinspection RubyResolve
        assigns(:rubric).should be_persisted
      end

      it "направляет на список рубрик" do
        post :create, {:rubric => valid_attributes}
        response.should redirect_to(rubrics_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved rubric as @rubric" do
        # Trigger the behavior that occurs when invalid params are submitted
        Rubric.any_instance.stub(:save).and_return(false)
        post :create, {:rubric => {}}
        assigns(:rubric).should be_a_new(Rubric)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Rubric.any_instance.stub(:save).and_return(false)
        post :create, {:rubric => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested rubric" do
        Rubric.any_instance.should_receive(:update_attributes).with({:these.to_s => 'params'})
        put :update, {:id => @rubric.to_param, :rubric => {:these => 'params'}}
      end

      it "assigns the requested rubric as @rubric" do
        put :update, {:id => @rubric.to_param, :rubric => valid_attributes}
        assigns(:rubric).should eq(@rubric)
      end

      it "направляет на список рубрик" do
        put :update, {:id => @rubric.to_param, :rubric => valid_attributes}
        response.should redirect_to(rubrics_url)
      end
    end

    describe "with invalid params" do
      it "assigns the rubric as @rubric" do
        Rubric.any_instance.stub(:save).and_return(false)
        put :update, {:id => @rubric.to_param, :rubric => {}}
        assigns(:rubric).should eq(@rubric)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Rubric.any_instance.stub(:save).and_return(false)
        put :update, {:id => @rubric.to_param, :rubric => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested rubric" do
      expect {
        delete :destroy, {:id => @rubric.to_param}
      }.to change(Rubric, :count).by(-1)
    end
    it "redirects to the rubrics list" do
      delete :destroy, {:id => @rubric.to_param}
      #noinspection RubyResolve
      response.should redirect_to(rubrics_url)
    end
  end

end
