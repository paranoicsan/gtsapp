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

FactoryGirl.define do

  factory :company_status, class: Companies::Status do
    name 'Неизвестно'

    factory :company_status_active do
      name 'Активна'
    end

    factory :company_status_suspended do
      name 'На рассмотрении'
    end

    factory :company_status_second_suspend do
      name 'Повторное рассмотрение'
    end

    factory :company_status_archived do
      name 'В архиве'
    end

    factory :company_status_on_deletion do
      name 'На удалении'
    end

    factory :company_status_need_attention do
      name 'Требует внимания'
    end

    factory :company_status_need_improvement do
      name 'Требует доработки'
    end

  end

end
