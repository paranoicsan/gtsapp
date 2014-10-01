module Users

class User < ActiveRecord::Base

  has_many :companies, class_name: 'Companies::Company'
  has_many :histories, class_name: 'Companies::History'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  easy_roles :roles

  scope :agents, ->{ all.select { |u| u.has_role?('agent') } }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :last_name, :email, :password, :password_confirmation,
                  :remember_me, :roles

end

end