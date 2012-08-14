require "faker"

FactoryGirl.define do

  factory :user, aliases: [:agent, :author, :editor] do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password 12345
    password_confirmation 12345

    roles [:agent]

    factory :user_admin do
      roles [:admin]
    end

    factory :user_agent do
      roles [:agent]
    end

    factory :user_operator do
      roles [:operator]
    end

  end

end