# encoding: utf-8
require 'spec_helper'

describe ContractsController do

  before(:each) do
    authorize_user
    make_user_system

    @user = FactoryGirl.create :user_admin
    controller.stub(:current_user).and_return(@user)
  end

  let(:company) { FactoryGirl.create :company }

  def valid_attributes
    {
        company_id: company.id
    }
  end

  def create_valid
    FactoryGirl.create :contract, valid_attributes
  end
  
  describe "GET index" do
    it "assigns all contracts as @contracts" do
      contract = create_valid
      get :index, valid_attributes
      assigns(:contracts).should eq([contract])
    end
  end

  describe "GET show" do
    it "assigns the requested contract as @contract" do
      contract = create_valid
      get :show, {:id => contract.to_param}
      assigns(:contract).should eq(contract)
    end
  end

  describe "GET new" do
    it "assigns a new contract as @contract" do
      get :new, valid_attributes
      assigns(:contract).should be_a_new(Contract)
    end
  end

  describe "GET edit" do
    it "assigns the requested contract as @contract" do
      contract = create_valid
      get :edit, {:id => contract.to_param}
      assigns(:contract).should eq(contract)
    end
  end

  describe "POST create" do

    describe "with valid params" do

      def post_valid
        params = FactoryGirl.attributes_for :contract, company_id: company.id
        post :create, {:contract => params, :company_id => company.id}
      end

      it "creates a new Contract" do
        expect {
          post_valid
        }.to change(Contract, :count).by(1)
      end
      it "assigns a newly created contract as @contract" do
        post_valid
        assigns(:contract).should be_a(Contract)
        #noinspection RubyResolve
        assigns(:contract).should be_persisted
      end
      it "redirects to the created contract" do
        post_valid
        response.should redirect_to(Contract.last)
      end
      it "создаёт запись в истории компании" do
        expect {
          post_valid
        }.to change(History, :count).by(1)
      end
    end

    describe "with invalid params" do

      def post_invalid
        params = FactoryGirl.attributes_for :contract, company_id: company.id, number: nil
        post :create, {:contract => params, :company_id => company.id}
      end

      it "assigns a newly created but unsaved contract as @contract" do
        # Trigger the behavior that occurs when invalid params are submitted
        Contract.any_instance.stub(:save).and_return(false)
        post_invalid
        assigns(:contract).should be_a_new(Contract)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Contract.any_instance.stub(:save).and_return(false)
        post_invalid
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    let(:contract) { create_valid }

    describe "with valid params" do

      def put_valid
        put :update, :id => contract.to_param, :contract => valid_attributes
      end

      it "updates the requested contract" do
        p = HashWithIndifferentAccess.new(these: 'params')
        Contract.any_instance.should_receive(:update_attributes).with(p)
        put :update, :id => contract.to_param, :contract => p
      end

      it "assigns the requested contract as @contract" do
        put_valid
        assigns(:contract).should eq(contract)
      end

      it "redirects to the contract" do
        put_valid
        response.should redirect_to(contract)
      end

      it "создаёт запись в истории компании" do
        expect {
          put_valid
        }.to change(History, :count).by(1)
      end
    end

    describe "with invalid params" do

      def put_invalid
        put :update, :id => contract.to_param, :contract => {}
      end

      it "assigns the contract as @contract" do
        Contract.any_instance.stub(:save).and_return(false)
        put_invalid
        assigns(:contract).should eq(contract)
      end

      it "re-renders the 'edit' template" do
        Contract.any_instance.stub(:save).and_return(false)
        put_invalid
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contract" do
      contract = create_valid
      expect {
        delete :destroy, {:id => contract.to_param}
      }.to change(Contract, :count).by(-1)
    end
    it "redirects to the contracts list" do
      contract = create_valid
      delete :destroy, {:id => contract.to_param}
      #noinspection RubyResolve
      response.should redirect_to(company_url(company))
    end
    it "создаёт запись в истории компании" do
      expect {
        contract = create_valid
        delete :destroy, {:id => contract.to_param}
      }.to change(History, :count).by(1)
    end
  end

end
