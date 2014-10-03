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

class Users::User < ActiveRecord::Base

  has_many :companies, class_name: 'Companies::Company'
  has_many :histories, class_name: 'Companies::History'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  easy_roles :roles

  set_table_name 'users_users'

  scope :agents, ->{ all.select { |u| u.has_role?('agent') } }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :last_name, :email, :password, :password_confirmation,
                  :remember_me, :roles

end
