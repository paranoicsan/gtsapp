# Encoding: utf-8
require "spec_helper"
require "shared/auth_helper"

describe DashboardController do

  RSpec.configure do |c|
    c.include AuthHelper
  end

  before(:each) do
    authorize_user
    @user = FactoryGirl.create :user
    controller.stub(:current_user).and_return(@user) # подмена текущего пользователя
  end

  describe "GET index" do

    before(:each) do
      @company_status_suspended = FactoryGirl.create :company_status_suspended
      @company_status_deleted = FactoryGirl.create :company_status_on_deletion
    end

    context "отображение договоров" do
      it "присваивает договора на рассмотрении как @suspended_contracts" do
        contract = FactoryGirl.create :contract
        get :index
        assigns(:suspended_contracts).should eq([contract])
      end
    end

    context "отображение компаний" do

      it "присваивает компании на рассмотрении как @suspended_companies" do
        attrs = {
            company_status: @company_status_suspended,
            author: @user
        }
        company = FactoryGirl.create :company, attrs
        get :index
        assigns(:suspended_companies).should eq([company])
      end

      it "присваивает компании на удалении как @queued_for_delete_copmanies" do
        attrs = {
            company_status: @company_status_deleted,
            reason_deleted_on: Faker::Lorem.sentence,
            author: @user
        }
        company = FactoryGirl.create :company, attrs
        get :index
        assigns(:queued_for_delete_companies).should eq([company])
      end

    end










  end

end