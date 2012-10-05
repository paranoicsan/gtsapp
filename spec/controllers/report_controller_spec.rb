# Encoding: utf-8
require 'spec_helper'

describe ReportController do

  ##
  # Создаёт и возвращет компанию по указанной улице
  def create_company_for(street, status_id, rubricator)
    com = FactoryGirl.create :company, company_status_id: status_id, rubricator: rubricator
    b = FactoryGirl.create :branch, company_id: com.id
    FactoryGirl.create :address, branch_id: b.id, city_id: street.city.id, street_id: street.id
    com
  end

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
        @company = FactoryGirl.create :company, company_status_id: FactoryGirl.create(:company_status_active).id,
                                      rubricator: 3
        b = FactoryGirl.create :branch, company_id: @company.id
        FactoryGirl.create :address, branch_id: b.id, city_id: @street.city.id, street_id: @street.id
      end

      def valid_attributes
        {
            street_id: @street.id,
            filter: :active,
            format: :js,
            rubricator_filter: 3
        }
      end

      def post_valid
        post :prepare_company_by_street, valid_attributes
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

      context "сохраняет параметры формирования отчёта в сессии" do
        before(:each) do
          post_valid
        end
        it "сохраняет ключ улицы" do
          session[:report_params][:street_id].should eq(valid_attributes[:street_id])
        end
        it "сохраняет фильтр по статусу компании" do
          session[:report_params][:filter].should eq(valid_attributes[:filter])
        end
        it "сохраняет фильтр по рубрикатору" do
          session[:report_params][:rubricator_filter].should eq(valid_attributes[:rubricator_filter])
        end
      end
      context "фильтр по рубрикатору" do
        it "возвращает фильтр рубрикатора как элемент Hash" do
          post_valid
          assigns(:report_result)[:rubricator_filter].should eq(3)
        end
        it "возвращает компании с полным рубрикатором когда указан полный фильтр" do
          @company.update_attribute "rubricator", 3
          params = valid_attributes
          params[:rubricator_filter] = 3
          post :prepare_company_by_street, params
          assigns(:report_result)[:companies].should eq([@company])
        end
        it "возвращает компании с полным или коммерческим рубрикатором когда указан коммерческий фильтр" do

          # создаём ещё одну компанию с другим рубрикатором
          com = create_company_for @street, CompanyStatus.active.id, 2
          com2 = create_company_for @street, CompanyStatus.active.id, 3

          @company.update_attribute "rubricator", 1
          params = valid_attributes
          params[:rubricator_filter] = 2
          post :prepare_company_by_street, params
          assigns(:report_result)[:companies].should eq([com, com2])
        end
        it "возвращает компании с полным или социальным рубрикатором когда указан социальный фильтр" do
          # создаём ещё одну компанию с другим рубрикатором
          com = create_company_for @street, CompanyStatus.active.id, 1
          com2 = create_company_for @street, CompanyStatus.active.id, 3

          @company.update_attribute "rubricator", 2
          params = valid_attributes
          params[:rubricator_filter] = 1
          post :prepare_company_by_street, params
          assigns(:report_result)[:companies].should eq([com, com2])
        end
      end
    end

    describe "GET company_by_street_export" do
      before(:each) do
        # создаём полный набор атрибутов для компании для покрытия кода
        street = FactoryGirl.create(:street)
        session[:report_params] = {
            street_id: street.id,
            filter: :active,
            format: :js,
            rubricator_filter: 3
        }
        company = create_company_for street, FactoryGirl.create(:company_status_active).id, 3
        FactoryGirl.create :person, company_id: company.id
        company.rubrics << FactoryGirl.create(:rubric)

        b = FactoryGirl.create :branch, company_id: company.id
        FactoryGirl.create :address, branch_id: b.id, city_id: street.city.id, street_id: street.id

        b.emails << FactoryGirl.create(:email)
        b.websites << FactoryGirl.create(:website)

        b.phones << FactoryGirl.create(:phone, branch_id: b.id)
        FactoryGirl.create(:contract_active, company_id: company.id)
      end
      it "возвращает сгенерированный PDF" do
        controller.stub(:render)
        controller.should_receive(:send_data)
        get :company_by_street_export, format: :pdf
      end
      it "возвращает сгенерированный RTF" do
        controller.stub(:render)
        controller.should_receive(:send_data)
        get :company_by_street_export, format: :rtf
      end
      it "возвращает сгенерированный XLS" do
        controller.stub(:render)
        controller.should_receive(:send_data)
        get :company_by_street_export, format: :xls
      end
    end

  end

end
