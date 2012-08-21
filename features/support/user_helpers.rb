# Encoding: utf-8

module UsersHelpers

  def find_user(user_name)
    User.find_by_username user_name
  end

end

World(UsersHelpers)