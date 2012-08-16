# Encoding: utf-8
require 'spec_helper'
require 'shared/auth_helper'

describe PeopleController do

  before(:each) do
    authorize_user
    make_user_admin

    @user = FactoryGirl.create :user_admin
    controller.stub(:current_user).and_return(@user) # подмена текущего пользователя
  end

  let(:company) { FactoryGirl.create :company }

  def valid_attributes
    {
        company_id: company.id
    }
  end

  def create_valid
    FactoryGirl.create :person, valid_attributes
  end

  describe "GET index" do
    it "assigns all people as @people" do
      person = create_valid
      get :index, valid_attributes
      assigns(:people).should eq([person])
    end
  end

  describe "GET show" do
    it "assigns the requested person as @person" do
      person = create_valid
      get :show, {:id => person.to_param}
      assigns(:person).should eq(person)
    end
  end

  describe "GET new" do
    it "assigns a new person as @person" do
      get :new, valid_attributes
      assigns(:person).should be_a_new(Person)
    end
  end

  describe "GET edit" do
    it "assigns the requested person as @person" do
      person = create_valid
      get :edit, {:id => person.to_param}
      assigns(:person).should eq(person)
    end
  end

  describe "POST create" do
    describe "with valid params" do

      def post_valid
        params = FactoryGirl.attributes_for :person, company_id: company.id
        post :create, {:person => params, :company_id => company.id}
      end

      it "creates a new Person" do
        expect {
          post_valid
        }.to change(Person, :count).by(1)
      end

      it "assigns a newly created person as @person" do
        post_valid
        assigns(:person).should be_a(Person)
        assigns(:person).should be_persisted
      end

      it "redirects to the created person" do
        post_valid
        response.should redirect_to(Person.last)
      end
    end

    describe "with invalid params" do

      def post_invalid
        params = FactoryGirl.attributes_for :person, company_id: company.id, name: nil
        post :create, {:person => params, :company_id => company.id}
      end

      it "assigns a newly created but unsaved person as @person" do
        # Trigger the behavior that occurs when invalid params are submitted
        Person.any_instance.stub(:save).and_return(false)
        post_invalid
        assigns(:person).should be_a_new(Person)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Person.any_instance.stub(:save).and_return(false)
        post_invalid
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    let(:person) { create_valid }

    describe "with valid params" do

      def put_valid
        put :update, :id => person.to_param, :person => valid_attributes
      end

      it "updates the requested person" do
        p = HashWithIndifferentAccess.new(these: 'params')
        Person.any_instance.should_receive(:update_attributes).with(p)
        put :update, :id => person.to_param, :person => p
      end

      it "assigns the requested person as @person" do
        put_valid
        assigns(:person).should eq(person)
      end

      it "перенаправляет на страницу компании" do
        put_valid
        response.should redirect_to(company_url(company))
      end
    end

    describe "with invalid params" do

      def put_invalid
        put :update, :id => person.to_param, :person => {}
      end

      it "assigns the person as @person" do
        Person.any_instance.stub(:save).and_return(false)
        put_invalid
        assigns(:person).should eq(person)
      end

      it "re-renders the 'edit' template" do
        Person.any_instance.stub(:save).and_return(false)
        put_invalid
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested person" do
      person = create_valid
      expect {
        delete :destroy, {:id => person.to_param}
      }.to change(Person, :count).by(-1)
    end

    it "перенаправляет на страницу компании" do
      person = create_valid
      delete :destroy, {:id => person.to_param}
      response.should redirect_to(company_url(company))
    end
  end

end
