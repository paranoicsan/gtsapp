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

  # подмена авторизованного пользователя
  def authorize_user
    controller.stub(:require_user).and_return(true)
  end

  # подмена оператора
  def make_user_operator
    authorize_user
    controller.stub(:require_operator).and_return(true)
  end

  # подмена админстратора
  def make_user_admin
    authorize_user
    controller.stub(:require_admin).and_return(true)
  end

  # подмена системных пользователй
  def make_user_system
    authorize_user
    controller.stub(:require_system_users).and_return(true)
  end

end