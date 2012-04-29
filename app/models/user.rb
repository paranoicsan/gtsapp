class User < ActiveRecord::Base
  has_many :companies
  easy_roles :roles
  acts_as_authentic
end
