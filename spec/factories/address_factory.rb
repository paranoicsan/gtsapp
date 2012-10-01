require "faker"

FactoryGirl.define do

  factory :address do |a|
    a.cabinet 2
    a.case 1
    a.entrance 34
    a.house 456
    a.litera "A"
    a.office 345
    a.other { Faker::Lorem.words.join(" ") }
    a.pavilion 44
    a.stage 8

    a.branch
    a.city
    #a.district
    #a.post_index
    a.street

  end



end