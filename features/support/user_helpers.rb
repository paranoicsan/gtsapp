# Encoding: utf-8

module UsersHelpers

  def find_user(user_name)
    User.find_by_username user_name
  end

  ##
  # Создаёт указанное число агентов в системе
  def create_agents(cnt=1)
    cnt.times do
      @agent = FactoryGirl.create :user_agent
    end
  end

end

World(UsersHelpers)