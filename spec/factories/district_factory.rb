# Encoding: utf-8
require "faker"

FactoryGirl.define do

  factory :district do
    name { ["район", Faker::Name.name].join(" ") }
  end

end