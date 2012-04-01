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

  # Заполняет форму авторизации и пытается войти
  # @param user [User] Пользователь, который пытается аойти в систему
  # @param plain_password [String] Открытый пароль для ввода значений
  def login(user, plain_password = nil)
    pwd = plain_password ? plain_password : user.password
    fill_in "user_session_username", :with => user.username
    fill_in "user_session_password", :with => pwd
    click_button "login_bt"
  end

end

World(LoginHelpers)