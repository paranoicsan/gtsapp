# encoding: utf-8
require 'spec_helper'

describe BranchesController do

  let(:company) { FactoryGirl.create :company }
  
  before(:each) do
    authorize_user

    @user = FactoryGirl.create :user
    controller.stub(:current_user).and_return(@user)
  end

  # This should return the minimal set of attributes required to create a valid
  # Branch. As you add validations to Branch, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        company_id: company.id
    }
  end

  def create_valid
    FactoryGirl.create :branch, company: company
  end
  
  describe 'GET show' do
    it 'assigns the requested branch as @branch' do
      branch = create_valid
      get :show, id: branch.to_param
      assigns(:branch).should eq(branch)
    end
  end

  describe 'GET new' do
    it 'assigns a new branch as @branch' do
      get :new, valid_attributes
      assigns(:branch).should be_a_new(Branch)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested branch as @branch' do
      branch = create_valid
      get :edit, id: branch.to_param
      assigns(:branch).should eq(branch)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do

      def post_valid
        params = FactoryGirl.attributes_for :branch
        post :create, {branch: params, company_id: company.id}
      end

      it 'creates a new Branch' do
        expect {
          post_valid
        }.to change(Branch, :count).by(1)
      end
      it 'assigns a newly created branch as @branch' do
        post_valid
        assigns(:branch).should be_a(Branch)
        #noinspection RubyResolve
        assigns(:branch).should be_persisted
      end
      it 'redirects to the created branch' do
        post_valid
        response.should redirect_to(Branch.last)
      end
      it 'создаёт запись в истории компании' do
        expect {
          post_valid
        }.to change(History, :count).by(1)
      end
    end
    describe 'with invalid params' do

      def post_invalid
        params = FactoryGirl.attributes_for :branch, company_id: nil
        post :create, {branch: params, company_id: company.id}
      end

      it 'assigns a newly created but unsaved branch as @branch' do
        # Trigger the behavior that occurs when invalid params are submitted
        Branch.any_instance.stub(:save).and_return(false)
        post_invalid
        assigns(:branch).should be_a_new(Branch)
      end

      it 're-renders the "new" template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Branch.any_instance.stub(:save).and_return(false)
        post_invalid
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do

    let(:branch) { create_valid }

    describe 'with valid params' do

      def put_valid
        put :update, id: branch.to_param, branch: valid_attributes
      end

      it 'updates the requested branch' do
        p = HashWithIndifferentAccess.new(these: 'params')
        Branch.any_instance.should_receive(:update_attributes).with(p)
        put :update, id: branch.to_param, branch: p
      end
      it 'assigns the requested branch as @branch' do
        put_valid
        assigns(:branch).should eq(branch)
      end
      it 'redirects to the branch' do
        put_valid
        response.should redirect_to(branch)
      end
      it 'создаёт запись в истории компании' do
        expect {
          put_valid
        }.to change(History, :count).by(1)
      end
    end

    describe 'with invalid params' do

      def put_invalid
        put :update, id: branch.to_param, branch: {}
      end

      it 'assigns the branch as @branch' do
        Branch.any_instance.stub(:save).and_return(false)
        put_invalid
        assigns(:branch).should eq(branch)
      end

      it 're-renders the "edit" template' do
        Branch.any_instance.stub(:save).and_return(false)
        put_invalid
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested branch' do
      branch = create_valid
      expect {
        delete :destroy, id: branch.to_param
      }.to change(Branch, :count).by(-1)
    end
    it 'перенаправляет на страницу компании' do
      branch = create_valid
      delete :destroy, id: branch.to_param
      #noinspection RubyResolve
      response.should redirect_to(company_url(company))
    end
    it 'создаёт запись в истории компании' do
      expect {
        branch = create_valid
        delete :destroy, id: branch.to_param
      }.to change(History, :count).by(1)
    end
  end

  describe 'POST add_website' do
    let(:branch) { create_valid }
    def add_valid
      post :add_website, id: branch.to_param, branch_website: Faker::Internet.url
    end
    it 'добавляет сайт к филиалу' do
      expect {
        add_valid
      }.to change(branch.websites, :count).by(1)
    end
    it 'создаёт запись в истории компании' do
      expect {
        add_valid
      }.to change(History, :count).by(1)
    end
  end

  describe 'GET delete_website' do
    before(:each) do
      @branch = create_valid
      @branch.websites << FactoryGirl.create(:website)
      @branch.save
      make_user_system
    end
    def delete_valid
      id = @branch.websites.first.id
      get :delete_website, id: @branch.to_param, website_id: id
    end
    it 'удаляет сайт из филиала' do
      expect {
        delete_valid
      }.to change(@branch.websites, :count).by(-1)
    end
    it 'создаёт запись в истории компании' do
      expect {
        delete_valid
      }.to change(History, :count).by(1)
    end
  end

  describe 'POST add_email' do
    let(:branch) { create_valid }
    def add_valid
      post :add_email, id: branch.to_param, branch_email: Faker::Internet.email
    end
    it 'добавляет почту к филиалу' do
      expect {
        add_valid
      }.to change(Email, :count).by(1)
    end
    it 'создаёт запись в истории компании' do
      expect {
        add_valid
      }.to change(History, :count).by(1)
    end
  end

  describe 'GET delete_email' do
    let(:email) { FactoryGirl.create :email }
    before(:each) do
      @branch = create_valid
      @branch.emails << email
      @branch.save
    end
    def delete_valid
      get :delete_email, id: @branch.to_param, email_id: email.id
    end
    it 'удаляет почту из филиала' do
      expect {
        delete_valid
      }.to change(Email, :count).by(-1)
    end
    it 'создаёт запись в истории компании' do
      expect {
        delete_valid
      }.to change(History, :count).by(1)
    end
  end

end
