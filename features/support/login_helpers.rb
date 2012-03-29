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
  def login(user)
    fill_in "user_session_username", :with => user.username
    fill_in "user_session_password", :with => user.password
    click_button "login_bt"
  end

end

World(LoginHelpers)