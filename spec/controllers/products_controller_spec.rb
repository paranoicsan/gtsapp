# Encoding: utf-8
require 'spec_helper'
require 'shared/auth_helper'

describe ProductsController do

  before(:each) do
    make_user_system

    @user = FactoryGirl.create :user_admin
    controller.stub(:current_user).and_return(@user) # подмена текущего пользователя
  end

  let(:contract) { FactoryGirl.create :contract }

  def valid_attributes
    {
      contract_id: contract.id,
      product_id: FactoryGirl.create(:product_type)
    }
  end

  def create_valid
    FactoryGirl.create :product, valid_attributes
  end

  describe "GET show" do
    it "assigns the requested product as @product" do
      product = create_valid
      get :show, {:id => product.to_param}
      assigns(:product).should eq(product)
    end
    it "присваивает родительский договор как @contract" do
      product = create_valid
      get :show, {:id => product.to_param}
      assigns(:contract).should eq(product.contract)
    end
  end

  describe "GET new" do
    it "для не активного договора может администратор" do
      c = FactoryGirl.create :contract_suspended
      params = {
        product_id: valid_attributes[:product_id],
        contract_id: c.id
      }
      get :new, params
      response.should be_success
    end
    it "для не активного договора может оператор" do
      user = FactoryGirl.create :user_operator
      controller.stub(:current_user).and_return(user) # подмена текущего пользователя
      c = FactoryGirl.create :contract_suspended
      params = {
          product_id: valid_attributes[:product_id],
          contract_id: c.id
      }
      get :new, params
      response.should be_success
    end

    it "assigns a new product as @product" do
      get :new, valid_attributes
      assigns(:product).should be_a_new(Product)
    end
  end

  describe "GET edit" do
    it "assigns the requested product as @product" do
      product = create_valid
      get :edit, {:id => product.to_param}
      assigns(:product).should eq(product)
    end
  end

  describe "POST create" do
    describe "with valid params" do

      def post_valid
        params = FactoryGirl.attributes_for :product, contract_id: contract.id
        post :create, {:product => params, :contract_id => contract.id}
      end

      it "creates a new Product" do
        expect {
          post_valid
        }.to change(Product, :count).by(1)
      end

      it "assigns a newly created product as @product" do
        post_valid
        assigns(:product).should be_a(Product)
        assigns(:product).should be_persisted
      end

      it "присваивает родительский договор как @contract" do
        post_valid
        assigns(:contract).should eq(contract)
      end

      it "перенаправляет на страницу договора" do
        post_valid
        response.should redirect_to(contract_url(contract))
      end
    end

    describe "with invalid params" do

      def post_invalid
        params = FactoryGirl.attributes_for :product, contract_id: contract.id, product_id: nil
        post :create, {:product => params, :contract_id => contract.id}
      end

      it "assigns a newly created but unsaved product as @product" do
        Product.any_instance.stub(:save).and_return(false)
        post_invalid
        assigns(:product).should be_a_new(Product)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        post_invalid
        response.should render_template("new")
      end

      it "присваивает родительский договор как @contract" do
        post_invalid
        assigns(:contract).should eq(contract)
      end
    end
  end

  describe "PUT update" do

    let(:product) { create_valid }

    describe "with valid params" do

      def put_valid
        put :update, :id => product.to_param, :product => valid_attributes
      end

      it "updates the requested product" do
        p = HashWithIndifferentAccess.new(these: 'params')
        Product.any_instance.should_receive(:update_attributes).with(p)
        put :update, :id => product.to_param, :product => p
      end

      it "assigns the requested product as @product" do
        put_valid
        assigns(:product).should eq(product)
      end

      it "перенаправляет на страницу договора" do
        put_valid
        response.should redirect_to(contract_url(contract))
      end

      it "присваивает родительский договор как @contract" do
        put_valid
        assigns(:contract).should eq(contract)
      end
    end

    describe "with invalid params" do

      def put_invalid
        put :update, :id => product.to_param, :product => {}
      end

      it "assigns the product as @product" do
        product = Product.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => {}}
        assigns(:product).should eq(product)
      end

      it "re-renders the 'edit' template" do
        put_invalid
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => {}}
        response.should render_template("edit")
      end

      it "присваивает родительский договор как @contract" do
        put_invalid
        assigns(:contract).should eq(contract)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested product" do
      product = create_valid
      expect {
        delete :destroy, {:id => product.to_param}
      }.to change(Product, :count).by(-1)
    end

    it "перенаправляет на страницу договора" do
      product = create_valid
      delete :destroy, {:id => product.to_param}
      response.should redirect_to(contract_url(contract))
    end
  end

  describe ".get_contract" do
    it "возвращает компанию по параметру из URL" do
      get :new, valid_attributes
      assigns(:contract).should eq(contract)
    end
  end

end
