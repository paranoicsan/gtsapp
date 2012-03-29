module LoginHelpers

  # Создает пользователя с предопределенными параметрами
  # @param [String] Роль пользователя
  # @return [User] Созданный пользователь
  def create_user(role = nil)
    username = "test_username@t.com"
    pwd = "test_password"
    params = {
        :username => username,
        :email => username,
        :password => pwd,
        :password_confirmation => pwd,
        :roles => [role]
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