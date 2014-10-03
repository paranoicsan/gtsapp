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

require 'spec_helper'

describe Users::User do

  it 'has valid factory' do
    user = FactoryGirl.create :user
    user.should be_valid
  end

end
