FactoryGirl.define do

  factory :address, class: Addresses::Address do |a|
    a.cabinet 2
    a.case 1
    a.entrance 34
    a.house 456
    a.litera 'A'
    a.office 345
    a.other { Faker::Lorem.words.join(" ") }
    a.pavilion 44
    a.stage 8

    a.branch
    a.city
    a.street

  end

end