# encoding: utf-8
require 'spec_helper'

describe Company do

  it "Фабрика корректна" do
    #noinspection RubyResolve
    FactoryGirl.create(:company).should be_valid
  end

  it "компания не может быть создана без названия" do
    company = FactoryGirl.build(:company, title: nil)
    company.should have(1).error_on(:title)
    #noinspection RubyResolve
    company.should_not be_valid
  end

  describe ".queue_for_delete может быть поставлена в очередь на удаление" do

    context "агент ставит компанию на удаление" do

      let(:company) { FactoryGirl.create :company }
      let(:status_active) { FactoryGirl.create :company_status_active }
      let(:status_archived) { FactoryGirl.create :company_status_archived }
      let(:status_suspended) { FactoryGirl.create :company_status_suspended }
      let(:status_deletion) { FactoryGirl.create :company_status_on_deletion }

      it "активную компанию" do
        company.company_status = status_active
        expect {
          company.queue_for_delete
        }.to change(company, :company_status).from(status_active).to(status_deletion)
      end

      it "архивную компанию" do
        company.company_status = status_archived
        expect {
          company.queue_for_delete
        }.to change(company, :company_status).from(status_archived).to(status_deletion)
      end

      it "компанию на рассмотрении" do
        company.company_status = status_suspended
        expect {
          company.queue_for_delete
        }.to change(company, :company_status).from(status_suspended).to(status_deletion)
      end

      pending "нельзя поставить компанию на удаление, если она уже поставлена на удаление" do
        company.company_status = status_deletion
        expect {
          company.queue_for_delete
        }.to raise
      end

      it "нельзя поставить компанию на удаление без описания причины" do

      end

    end



  end

  describe "Показывает тот или иной рубрикатор в разном виде" do

    before(:each) do
      @company = FactoryGirl.create :company
    end

    context "должна возвращать отдельные виды рубрикатора" do

      it "возврат социального рубрикатора" do
        @company.rubricator = 1
        assert @company.social_rubricator?, "Должен быть только социальный рубрикатор"
      end
      it "возврат коммерческого рубрикатора" do
        @company.rubricator = 2
        assert @company.commercial_rubricator?, "Должен быть только коммерческий рубрикатор"
      end
      it "возврат полного рубрикатора" do
        @company.rubricator = 3
        assert @company.full_rubricator?, "Должен быть полный рубрикатор"
      end
    end

    context "возвращает текстовое название рубрикатора или рубрикаторов, связанных с компанией" do
      it "возврат имени социального рубрикатора" do
        @company.rubricator = 1
        assert @company.rubricator_name == "Социальный", "Социальный рубрикатор не выводится по имени"
      end
      it "возврат имени коммерческого рубрикатора" do
        @company.rubricator = 2
        assert @company.rubricator_name == "Коммерческий", "Коммерческий рубрикатор не выводится по имени"
      end
      it "возврат имени полного рубрикатора" do
        @company.rubricator = 3
        assert @company.rubricator_name == "Полный", "Полный рубрикатор не выводится по имени"
      end
    end

  end

  describe "Создаётся с тем или иным состоянием, в зависимости от прав автора" do

    it "статус АКТИВНА, если создаёт админ" do
      user = FactoryGirl.create(:user_admin)
      status = FactoryGirl.create :company_status_active
      company = FactoryGirl.create(:company, author: user, editor: user)
      #noinspection RubyResolve
      company.company_status.should eq(status)
      end

    it "статус АКТИВНА, если создаёт оператор" do
      user = FactoryGirl.create(:user_operator)
      status = FactoryGirl.create :company_status_active
      company = FactoryGirl.create(:company, author: user, editor: user)
      #noinspection RubyResolve
      company.company_status.should eq(status)
    end

    it "статус НА РАССМОТРЕНИИ, если создаёт агент" do
      status = FactoryGirl.create :company_status_suspended
      company = FactoryGirl.create :company
      #noinspection RubyResolve
      company.company_status.should eq(status)
    end

  end

end
