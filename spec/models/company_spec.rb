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

  describe "#queue_for_delete" do

    let(:company) { FactoryGirl.create :company }
    let(:status_active) { FactoryGirl.create :company_status_active }
    let(:status_archived) { FactoryGirl.create :company_status_archived }
    let(:status_suspended) { FactoryGirl.create :company_status_suspended }
    let(:status_deletion) { FactoryGirl.create :company_status_on_deletion }

    context "агент может выставить компанию на удаление" do

      it "активная компания меняет статус на 'На удаление'" do
        company.company_status = status_active
        expect {
          company.queue_for_delete
        }.to change(company, :company_status).from(status_active).to(status_deletion)
      end

      it "архивная компания меняет статус на 'На удаление'" do
        company.company_status = status_archived
        expect {
          company.queue_for_delete
        }.to change(company, :company_status).from(status_archived).to(status_deletion)
      end

      it "компания на рассмотрении меняет статус на 'На удаление'" do
        company.company_status = status_suspended
        expect {
          company.queue_for_delete
        }.to change(company, :company_status).from(status_suspended).to(status_deletion)
      end

      it "вызывает ошибку, если не указан причина удаления" do
        company.company_status = status_deletion
        company.queue_for_delete
        company.should have(1).error_on(:reason_deleted_on)
      end

      it "ставится на удаление, если указана причина" do
        company.company_status = status_deletion
        company.queue_for_delete "Причина"
        company.should be_valid
      end

    end

  end

  describe "#unqueue_for_delete" do

    let(:company) { FactoryGirl.create :company }
    let(:status_active) { FactoryGirl.create :company_status_active }
    let(:status_archived) { FactoryGirl.create :company_status_archived }
    let(:status_suspended) { FactoryGirl.create :company_status_suspended }
    let(:status_deletion) { FactoryGirl.create :company_status_on_deletion }

    it "меняет статус компании на указанный активный" do
      company.company_status = status_deletion
      expect {
        company.unqueue_for_delete :active
      }.to change(company, :company_status).from(status_deletion).to(status_active)
    end
    it "меняет статус компании на указанный на рассмотрении" do
      company.company_status = status_deletion
      expect {
        company.unqueue_for_delete :suspended
      }.to change(company, :company_status).from(status_deletion).to(status_suspended)
    end
    it "не меняет статус компании если архивный статус" do
      company.company_status = status_deletion
      expect {
        company.unqueue_for_delete :archived
      }.not_to change(company, :company_status).from(status_deletion).to(status_archived)
    end
    it "не меняет статус компании если изначально не был статус на удалении" do
      company.company_status = status_archived
      expect {
        company.unqueue_for_delete :suspended
      }.not_to change(company, :company_status).from(status_archived).to(status_suspended)
    end
    it "вызывает ошибку, если передан не существующий новый статус" do
      company.company_status = status_deletion
      expect {
        company.unqueue_for_delete :unknown
      }.to raise_error
    end
  end

  describe "#queued_for_deletion?" do
    let(:company) { FactoryGirl.create :company }
    let(:status_active) { FactoryGirl.create :company_status_active }
    let(:status_deletion) { FactoryGirl.create :company_status_on_deletion }

    it "возвращает истину, если компания помечена на удаление" do
      company.company_status = status_deletion
      company.queued_for_deletion?.should eq(true)
    end
    it "возвращает ложь, если компания не помечена на удаление" do
      company.queued_for_deletion?.should_not eq(true)
    end
  end

  describe ".queued_for_delete" do
    it "возвращает компании на удалении" do
      company = FactoryGirl.create :company_queued_for_delete
      Company.queued_for_delete.should eq([company])
    end
  end

  describe "#need_attention?" do
    let(:company) { FactoryGirl.create :company }
    let(:status) { FactoryGirl.create :company_status_need_attention }
    it "возвращает истину, если компания с указанным статусом" do
      company.company_status = status
      company.need_attention?.should be_true
    end
    it "возвращает ложь, если компания с любым другим статусом" do
      company.need_attention?.should be_false
    end
  end

  describe "#need_improvement?" do
    let(:company) { FactoryGirl.create :company }
    let(:status) { FactoryGirl.create :company_status_need_improvement }
    it "возвращает истину, если компания с указанным статусом" do
      company.company_status = status
      company.need_improvement?.should be_true
    end
    it "возвращает ложь, если компания с любым другим статусом" do
      company.need_improvement?.should be_false
    end
  end

  describe ".need_attention_list" do
    it "возвращает компании, требующие внимания" do
      params = {
          reason_need_attention_on: Faker::Lorem.sentence,
          company_status: FactoryGirl.create(:company_status_need_attention)
      }
      company = FactoryGirl.create :company, params
      Company.need_attention_list.should eq([company])
    end
  end

  describe ".need_improvement_list" do
    it "возвращает компании на доработке" do
      params = {
          reason_need_improvement_on: Faker::Lorem.sentence,
          company_status: FactoryGirl.create(:company_status_need_improvement)
      }
      company = FactoryGirl.create :company, params
      Company.need_improvement_list.should eq([company])
    end
  end

  describe ".need_improvement_list_by_user" do
    it "возвращает компании на доработке для агента-автора" do
      author = FactoryGirl.create(:user)
      params = {
          reason_need_improvement_on: Faker::Lorem.sentence,
          company_status: FactoryGirl.create(:company_status_need_improvement),
          author: author
      }

      company = FactoryGirl.create :company, params
      Company.need_improvement_list_by_user(author.id).should eq([company])
    end
  end

  describe "#archived?" do
    let(:company) { FactoryGirl.create :company }
    let(:status) { FactoryGirl.create :company_status_archived }
    it "возвращает истину, если компания с указанным статусом" do
      company.company_status = status
      company.archived?.should be_true
    end
    it "возвращает ложь, если компания с любым другим статусом" do
      company.archived?.should be_false
    end
  end

  describe ".activate" do

    before(:each) do
      @status_active = FactoryGirl.create :company_status_active
      @company = FactoryGirl.create :company_suspended
      @company.reason_need_attention_on = Faker::Lorem.sentences.join
      @company.reason_deleted_on = Faker::Lorem.sentences.join
      @company.reason_need_improvement_on = Faker::Lorem.sentences.join
    end

    it "меняет статус компании на активный" do
      Company.activate @company.id
      Company.find(@company.id).company_status.should eq(@status_active)
    end
    it "Сбрасывает причину запроса внимания" do
      Company.activate(@company.id)
      Company.find(@company.id).reason_need_attention_on.should be_nil
    end
    it "Сбрасывает причину удаления" do
      Company.activate(@company.id)
      Company.find(@company.id).reason_deleted_on.should be_nil
    end
    it "Сбрасывает причину отправки на доработку" do
      Company.activate(@company.id)
      Company.find(@company.id).reason_need_improvement_on.should be_nil
    end
  end

  describe "#archive" do
    before(:each)  do
      active_status = FactoryGirl.create :company_status_active
      @status = FactoryGirl.create :company_status_archived
      @company = FactoryGirl.create :company, company_status: active_status
    end
    it "меняет статус компании на архивный" do
      @company.archive
      @company.company_status.should eq(@status)
    end
    it "Сбрасывает причину запроса внимания" do
      @company.reason_need_attention_on = Faker::Lorem.sentences.join
      @company.archive
      @company.reason_need_attention_on.should be_nil
    end
    it "Сбрасывает причину удаления" do
      @company.reason_deleted_on = Faker::Lorem.sentences.join
      @company.archive
      @company.reason_deleted_on.should be_nil
    end
    it "Сбрасывает причину отправки на доработку" do
      @company.reason_need_improvement_on = Faker::Lorem.sentences.join
      @company.archive
      @company.reason_need_improvement_on.should be_nil
    end
  end

end
