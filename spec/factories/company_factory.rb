require "faker"

FactoryGirl.define do

  factory :company do

    comments { Faker::Lorem.sentence }
    #noinspection RubyResolve
    date_added { Date::today }
    title { Faker::Lorem.words 3 }
    rubricator 0

    author
    #noinspection RubyResolve
    editor
  end

end