FactoryGirl.define do

  factory :company, class: Companies::Company do

    comments { Faker::Lorem.sentence }
    date_added { Date::today }
    title { Faker::Lorem.words(3).join(' ') }
    rubricator 1

    author
    editor
    status { FactoryGirl.create :company_status }

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