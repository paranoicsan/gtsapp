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

  context "by_agent" do

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
        params = {
            report_agent: user.id,
            report_period_start: {
                month: 3.month.ago.month,
                year: 3.month.ago.year,
              },
            report_period_end: {
                month: DateTime.now.month,
                year: DateTime.now.year
                },
            format: :js
        }
        post :prepare_by_agent, params
      end
      it "возвращает искомого агента как @report_agent" do
        post_valid
        assigns(:report_agent).should eq(user)
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

  context "company_by_street" do

    describe "GET 'company_by_street'" do
      it "returns http success" do
        get :company_by_street
        response.should be_success
      end
    end

    describe "POST prepare_company_by_street" do

      before(:each) do
        @street = FactoryGirl.create :street
        @company = FactoryGirl.create :company
        b = FactoryGirl.create :branch, company_id: @company.id
        FactoryGirl.create :address, branch_id: b.id, city_id: @street.city.id, street_id: @street.id
      end

      def post_valid
        params = {
            street_id: @street.id,
            filter: :active,
            format: :js
        }
        post :prepare_company_by_street, params
      end

      it "возвращает объект улицы как элемент Hash" do
        post_valid
        assigns(:report_result)[:street].should eq(@street)
      end
      it "возвращает найденные компании как элеент Hash" do
        post_valid
        assigns(:report_result)[:companies].should eq([@company])
      end
      it "возвращает JavaScript-ответ для обновления данных на странице" do
        post_valid
        response.should be_success
      end
      it "поумолчанию возвращает флаг, что только активные компании надо искать" do
        post_valid
        assigns(:report_result)[:filter].should eq(:active)
      end
      it "возвращает тип компаний, который надо искать как элемент Hash" do
        params = {
            street_id: @street.id,
            filter: :all,
            format: :js
        }
        post :prepare_company_by_street, params
        assigns(:report_result)[:filter].should eq(:all)
      end
    end

  end

end