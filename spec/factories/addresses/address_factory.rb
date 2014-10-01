FactoryGirl.define do

  factory :address, class: Addresses::Address do
    cabinet 2
    entrance 34
    house 456
    litera 'A'
    office 345
    other { Faker::Lorem.words.join(' ') }
    pavilion 44
    stage 8

    association :branch, factory: :branch
    city
    street

    after(:create) do |a|
      a.case = 1
    end

  end

end