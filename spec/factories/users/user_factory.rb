FactoryGirl.define do

  factory :user, aliases: [:agent, :author, :editor], class: Users::User do
    email { Faker::Internet.email }
    username { "#{Faker::Internet.user_name}#{Faker::Lorem.words.join}" }
    password { Faker::Lorem.words.join }

    roles %w(agent)

    factory :user_admin do
      roles %w(admin)
    end

    factory :user_agent do
      roles %w(agent)
    end

    factory :user_operator do
      roles %w(operator)
    end

  end

end