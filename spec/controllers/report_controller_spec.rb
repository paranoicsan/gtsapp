# Encoding: utf-8
require 'spec_helper'

describe ReportController do

  before(:each) do
    make_user_system
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'by_agent'" do
    it "returns http success" do
      get :by_agent
      response.should be_success
    end
  end

  describe "POST prepare_by_agent" do

    let(:user) { FactoryGirl.create(:user_agent) }
    let(:company) { FactoryGirl.create(:company, author_user_id: user.id) }

    def write_history
      CompanyHistory.log("ttt", user.id, company.id)
    end

    def post_valid
      post :prepare_by_agent, agent_id: user.id, format: :js
    end
    it "возвращает набор данных как @report_result" do
      write_history
      post_valid
      assigns(:report_result).should eq([CompanyHistory.first])
    end
    it "возвращает JavaScript-ответ для обновления данных на странице" do
      post_valid
      response.should be_success
    end
  end


end
