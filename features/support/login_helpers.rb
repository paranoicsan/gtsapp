# Encoding: utf-8
module LoginHelpers

  # Создает пользователя с предопределенными параметрами
  # @return [User] Созданный пользователь
  def create_user
    username = "test_username@t.com"
    pwd = "test_password"
    params = {
        :username => username,
        :email => username,
        :password => pwd,
        :password_confirmation => pwd
    }
    User.new(params)
  end

  def create_user_wfactory(role)
    case role.downcase
      when "агент"
        s = :user_agent
      else
        raise "Не известные права доступа"
    end
    FactoryGirl.create s
  end

  # Заполняет форму авторизации и пытается войти
  # @param user [User] Пользователь, который пытается аойти в систему
  # @param plain_password [String] Открытый пароль для ввода значений
  def login(user, plain_password = nil)
    pwd = plain_password ? plain_password : user.password
    fill_in "user_session_username", :with => user.username
    fill_in "user_session_password", :with => pwd

    create_company_statuses # создаём статусы компаний

    click_button "login_bt"
  end

end

World(LoginHelpers)