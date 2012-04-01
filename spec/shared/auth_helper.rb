module AuthHelper

  # Возвращает хэш с минимальным набором параметров для создания
  # пользователя
  # @param role [String] Имя роли, которую надо присвоить
  # @return [Hash] с параметрами пользователя
  def user_params(role = nil)
    pwd = "1111"
    {
        :username => "username",
        :password => pwd,
        :email => "test@test.com",
        :password_confirmation => pwd,
        :roles => [role]
    }
  end

end