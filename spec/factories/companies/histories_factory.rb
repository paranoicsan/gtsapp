FactoryGirl.define do
  factory :company_history, class: Companies::History do
    user
    operation { Faker::Lorem.words(1).join }
    company
  end
end
