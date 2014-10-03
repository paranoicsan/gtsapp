# == Schema Information
#
# Table name: users_users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  roles                  :string(255)      default("--- []")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  sign_in_count          :integer
#
# Indexes
#
#  index_users_users_on_email                 (email) UNIQUE
#  index_users_users_on_id                    (id)
#  index_users_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryGirl.define do

  factory :user, aliases: [:agent, :author, :editor], class: Users::User do
    email { Faker::Internet.email }
    username { "#{Faker::Internet.user_name}#{Faker::Lorem.words.join}" }
    password 12345678

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
