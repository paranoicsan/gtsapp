module AuthHelper

  # подмена авторизованного пользователя
  def authorize_user
    controller.stub(:require_user).and_return(true)
  end

  # подмена оператора
  def make_user_operator
    authorize_user
    controller.stub(:require_operator).and_return(true)
  end

  # подмена администратора
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