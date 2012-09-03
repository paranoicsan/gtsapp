# encoding: utf-8
require 'spec_helper'

describe CompanyStatus do

  it "Фабрика корректна" do
    #noinspection RubyResolve
    FactoryGirl.create(:company_status).should be_valid
  end

  describe "возвращает объекты статуса по идентификатору" do

    it ".active возвращает объект активного статуса" do
      status = FactoryGirl.create :company_status_active
      CompanyStatus.active.should eq(status)
    end

    it ".suspended возвращает объект статуса на рассмотрении" do
      status = FactoryGirl.create :company_status_suspended
      CompanyStatus.suspended.should eq(status)
    end

    it ".archived возвращает объект архвиного статуса" do
      status = FactoryGirl.create :company_status_archived
      CompanyStatus.archived.should eq(status)
    end

    it ".deletion возвращает объект статуса очереди на удаление" do
      status = FactoryGirl.create :company_status_on_deletion
      CompanyStatus.queued_for_delete.should eq(status)
    end

    it ".need_review возвращает объект статуса Требует внимания" do
      status = FactoryGirl.create :company_status_need_attention
      CompanyStatus.need_attention.should eq(status)
    end

    it ".need_improvement возвращает объект статуса Требует доработки" do
      status = FactoryGirl.create :company_status_need_improvement
      CompanyStatus.need_improvement.should eq(status)
    end

    it ".second_suspend возвращает объект статуса Повторное рассмотрение" do
      status = FactoryGirl.create :company_status_second_suspend
      CompanyStatus.second_suspend.should eq(status)
    end
  end

end
