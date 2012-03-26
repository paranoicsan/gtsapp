class User < ActiveRecord::Base
  easy_roles :roles
  acts_as_authentic
end
