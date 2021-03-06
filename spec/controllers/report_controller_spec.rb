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

  context "company_by_rubric" do

    def create_data
      2.times { FactoryGirl.create :company_active }
      2.times { FactoryGirl.create :company_archived }
      @rubric = FactoryGirl.create :rubric
      Company.all.each do |c|
        c.rubrics << @rubric

        FactoryGirl.create :person, company_id: c.id

        street = FactoryGirl.create(:street)
        b = FactoryGirl.create :branch, company_id: c.id
        FactoryGirl.create :address, branch_id: b.id, city_id: street.city.id, street_id: street.id

        # второй филиал
        b = FactoryGirl.create :branch, company_id: c.id
        FactoryGirl.create :address, branch_id: b.id, city_id: street.city.id, street_id: street.id

        b.emails << FactoryGirl.create(:email)
        b.websites << FactoryGirl.create(:website)

        phone = FactoryGirl.create(:phone, branch: b)
        b.phones << phone
        FactoryGirl.create(:contract_active, company_id: c.id)
      end


    end

    describe "GET company_by_rubric" do
      it "возвращает положительный ответ" do
        get :company_by_rubric
        response.should be_success
      end
    end

    describe "POST prepare_company_by_rubric" do
      before(:each) do
        create_data
      end
      def post_valid2(filter = :all)
        params = {
            filter: filter,
            report_rubric: @rubric.id,
            format: :js
        }
        post :prepare_company_by_rubric, params
      end
      it "возвращает набор данных как @report_result" do
        post_valid2
        assigns(:report_result).should_not eq({})
      end
      it "возвращает название выбранной рубрики" do
        post_valid2
        assigns(:report_result)[:rubric_name].should eq(@rubric.name)
      end
      it "возвращает все компании, если выставлен фильтр" do
        companies = Company.all
        post_valid2
        assigns(:report_result)[:companies].should eq(companies)
      end
      it "возвращает активные компании, если выставлен фильтр" do
        companies = Company.active
        post_valid2 :active
        assigns(:report_result)[:companies].should eq(companies)
      end
      it "возвращает архивные компании, если выставлен фильтр" do
        companies = Company.archived
        post_valid2 :archived
        assigns(:report_result)[:companies].should eq(companies)
      end
      it "возвращает JavaScript-ответ для обновления данных на странице" do
        post_valid2
        response.should be_success
      end
    end

    describe "GET company_by_rubric/export" do
      before(:each) do
        create_data
        session[:report_params] = {
            format: :js,
            rubric_id: @rubric.id
        }
      end
      context "Активные" do
        before(:each) do
          session[:report_params][:filter] = :active
        end
        it "возвращает сгенерированный PDF" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :pdf
        end
        it "возвращает сгенерированный XLS" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :xls
        end
        it "возвращает сгенерированный RTF" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :rtf
        end
      end
      context "Архивные" do
        before(:each) do
          session[:report_params][:filter] = :archived
        end
        it "возвращает сгенерированный PDF" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :pdf
        end
        it "возвращает сгенерированный XLS" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :xls
        end
        it "возвращает сгенерированный RTF" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :rtf
        end
      end
      context "Все" do
        before(:each) do
          session[:report_params][:filter] = :all
        end
        it "возвращает сгенерированный PDF" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :pdf
        end
        it "возвращает сгенерированный XLS" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :xls
        end
        it "возвращает сгенерированный RTF" do
          controller.stub(:render)
          controller.should_receive(:send_data)
          get :company_by_rubric_export, format: :rtf
        end
      end
    end

  end

  context 'by_agent' do

    describe 'GET by_agent' do
      it 'returns http success' do
        get :by_agent
        response.should be_success
      end
    end

    describe 'POST prepare_by_agent' do

      let(:user) { FactoryGirl.create(:user_agent) }
      let(:company) { FactoryGirl.create(:company, author_user_id: user.id) }

      def write_history
        History.log('ttt', user.id, company.id)
      end

      def post_valid
        params = {
            report_agent: user.id,
            report_period_start: {
                day: 3.month.ago.day,
                month: 3.month.ago.month,
                year: 3.month.ago.year
              },
            report_period_end: {
                day: DateTime.now.day,
                month: DateTime.now.month,
                year: DateTime.now.year
                },
            format: :js
        }
        post :prepare_by_agent, params
      end
      it 'возвращает искомого агента как @report_agent' do
        post_valid
        assigns(:report_agent).should eq(user)
      end
      it 'возвращает изменённые в указанном периоде компании как @report_result' do
        write_history
        post_valid
        assigns(:report_result).should eq(company.id => [History.first])
      end
      it 'возвращает JavaScript-ответ для обновления данных на странице' do
        post_valid
        response.should be_success
      end
    end

  end

  context 'company_by_street' do

    def create_data
      2.times { FactoryGirl.create :company_active, rubricator: 3 }
      2.times { FactoryGirl.create :company_archived, rubricator: 3 }
      @street = FactoryGirl.create(:street)
      Company.all.each do |c|

        FactoryGirl.create :person, company_id: c.id

        b = FactoryGirl.create :branch, company_id: c.id
        FactoryGirl.create :address, branch_id: b.id, city_id: @street.city.id, street_id: @street.id

        # второй филиал
        b = FactoryGirl.create :branch, company_id: c.id
        FactoryGirl.create :address, branch_id: b.id, city_id: @street.city.id, street_id: @street.id

        b.emails << FactoryGirl.create(:email)
        b.websites << FactoryGirl.create(:website)

        phone = FactoryGirl.create(:phone, branch: b)
        b.phones << phone
        FactoryGirl.create(:contract_active, company_id: c.id)
      end
    end

    describe 'GET company_by_street' do
      it 'returns http success' do
        get :company_by_street
        response.should be_success
      end
    end

    describe 'POST prepare_company_by_street' do

      before(:each) do
        create_data
      end

      def post_valid(filter = :active)
        params = {
            filter: filter,
            street_id: @street.id,
            format: :js,
            rubricator_filter: 3
        }
        post :prepare_company_by_street, params
      end

      it 'возвращает объект улицы как элемент Hash' do
        post_valid
        assigns(:report_result)[:street].should eq(@street)
      end
      it 'активные: возвращает найденные компании как элеент Hash' do
        companies = Company.active
        post_valid :active
        assigns(:report_result)[:companies].should eq(companies)
      end
      it 'архивные: возвращает найденные компании как элеент Hash' do
        post_valid :archived
        assigns(:report_result)[:companies].should eq(Company.archived)
      end
      it 'все: возвращает найденные компании как элеент Hash' do
        post_valid :all
        assigns(:report_result)[:companies].should eq(Company.all)
      end
      it 'возвращает JavaScript-ответ для обновления данных на странице' do
        post_valid
        response.should be_success
      end
      it 'поумолчанию возвращает флаг, что только активные компании надо искать' do
        post_valid
        assigns(:report_result)[:filter].should eq(:active)
      end
      it 'все: возвращает тип компаний, который надо искать как элемент Hash' do
        post_valid :all
        assigns(:report_result)[:filter].should eq(:all)
      end
      it 'архивные: возвращает тип компаний, который надо искать как элемент Hash' do
        post_valid :archived
        assigns(:report_result)[:filter].should eq(:archived)
      end

      context 'сохраняет параметры формирования отчёта в сессии' do
        before(:each) do
          post_valid
        end
        it 'сохраняет ключ улицы' do
          session[:report_params][:street_id].should eq(@street.id)
        end
        it 'сохраняет фильтр по статусу компании' do
          session[:report_params][:filter].should eq(:active)
        end
        it 'сохраняет фильтр по рубрикатору' do
          session[:report_params][:rubricator_filter].should eq(3)
        end
      end
      context 'фильтр по рубрикатору' do
        def valid_attributes
          {
              filter: :all,
              street_id: @street.id,
              format: :js,
              rubricator_filter: 3
          }
        end
        it 'возвращает фильтр рубрикатора как элемент Hash' do
          post_valid
          assigns(:report_result)[:rubricator_filter].should eq(3)
        end
        it 'возвращает компании с полным рубрикатором когда указан полный фильтр' do
          companies = Company.all
          params = valid_attributes
          post :prepare_company_by_street, params
          assigns(:report_result)[:companies].should eq(companies)
        end
        it 'возвращает компании с полным или коммерческим рубрикатором когда указан коммерческий фильтр' do

          Company.all.each { |c| c.update_attribute 'rubricator', 1 }
          company = Company.archived.first
          company.update_attribute 'rubricator', 2
          params = valid_attributes
          params[:rubricator_filter] = 2
          post :prepare_company_by_street, params
          assigns(:report_result)[:companies].should eq([company])
        end
        it 'возвращает компании с полным или социальным рубрикатором когда указан социальный фильтр' do
          Company.all.each { |c| c.update_attribute 'rubricator', 2 }
          company = Company.archived.first
          company.update_attribute 'rubricator', 1
          params = valid_attributes
          params[:rubricator_filter] = 1
          post :prepare_company_by_street, params
          assigns(:report_result)[:companies].should eq([company])
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
