# == Schema Information
#
# Table name: companies_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_companies_statuses_on_id  (id)
#

require 'spec_helper'

describe Companies::Status do

  it 'Фабрика корректна' do
    status = FactoryGirl.create :company_status
    status.should be_valid
  end

  describe 'возвращает объекты статуса по идентификатору' do

    it '.active возвращает объект активного статуса' do
      status = FactoryGirl.create :company_status_active
      Companies::Status.active.should eq(status)
    end

    it '.suspended возвращает объект статуса на рассмотрении' do
      status = FactoryGirl.create :company_status_suspended
      Companies::Status.suspended.should eq(status)
    end

    it '.archived возвращает объект архвиного статуса' do
      status = FactoryGirl.create :company_status_archived
      Companies::Status.archived.should eq(status)
    end

    it '.deletion возвращает объект статуса очереди на удаление' do
      status = FactoryGirl.create :company_status_on_deletion
      Companies::Status.queued_for_delete.should eq(status)
    end

    it '.need_review возвращает объект статуса Требует внимания' do
      status = FactoryGirl.create :company_status_need_attention
      Companies::Status.need_attention.should eq(status)
    end

    it '.need_improvement возвращает объект статуса Требует доработки' do
      status = FactoryGirl.create :company_status_need_improvement
      Companies::Status.need_improvement.should eq(status)
    end

    it '.second_suspend возвращает объект статуса Повторное рассмотрение' do
      status = FactoryGirl.create :company_status_second_suspend
      Companies::Status.second_suspend.should eq(status)
    end
  end

end
