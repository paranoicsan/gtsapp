require "faker"

FactoryGirl.define do

  factory :company do

    comments { Faker::Lorem.sentence }
    #noinspection RubyResolve
    date_added { Date::today }
    title { Faker::Lorem.words(3).join(' ') }
    rubricator 1

    author
    #noinspection RubyResolve
    editor

    factory :company_active do
      company_status { FactoryGirl.create :company_status_active }
    end

    factory :company_archived do
      company_status { FactoryGirl.create :company_status_archived }
    end

    factory :company_suspended do
      company_status { FactoryGirl.create :company_status_suspended }
    end

    factory :company_queued_for_delete do
      reason_deleted_on { Faker::Lorem.sentence }
      company_status { FactoryGirl.create :company_status_on_deletion }
    end

  end

end