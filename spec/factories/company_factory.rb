require "faker"

FactoryGirl.define do

  factory :company do

    comments { Faker::Lorem.sentence }
    date_added { Date::today }
    title { Faker::Lorem.words 1 }
    rubricator 0

    user
    author
    editor
  end

end