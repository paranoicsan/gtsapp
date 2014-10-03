# == Schema Information
#
# Table name: companies_companies
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  date_added                 :date
#  rubricator                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  companies_status_id        :integer
#  author_user_id             :integer
#  editor_user_id             :integer
#  companies_source_id        :integer
#  agent_id                   :integer
#  comments                   :string(255)
#  reason_deleted_on          :string(255)
#  reason_need_attention_on   :string(255)
#  reason_need_improvement_on :string(255)
#

FactoryGirl.define do

  factory :company, class: Companies::Company do

    trait :general do
      comments { Faker::Lorem.sentence }
      date_added { Date::today }
      title { Faker::Lorem.words(3).join(' ') }
      rubricator 1

      author
      editor
    end

    general
    status { FactoryGirl.create :company_status_need_attention }
    reason_need_attention_on { Faker::Lorem.sentence }

    factory :company_active do
      status { FactoryGirl.create :company_status_active }
    end

    factory :company_archived do
      status { FactoryGirl.create :company_status_archived }
    end

    factory :company_suspended do
      status { FactoryGirl.create :company_status_suspended }
    end

    factory :company_queued_for_delete do
      reason_deleted_on { Faker::Lorem.sentence }
      status { FactoryGirl.create :company_status_on_deletion }
    end

  end

end
