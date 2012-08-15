# encoding: utf-8
Given /^Я - зарегистрированный пользователь$/ do
  @user = create_user
  @user.save_without_session_maintenance # решение https://github.com/binarylogic/authlogic/issues/262
end

When /^Я вхожу в систему$/ do
  step %{Я пытаюсь попасть на страницу авторизации}
  login @user
end

When /^Я пытаюсь войти в систему с неверными данными$/ do
  @user = User.new
  @user.username = ""
  @user.password = ""
  step "Я вхожу в систему"
end

Given /^Я авторизован в системе$/ do
  step %{Я - зарегистрированный пользователь}
  step %{Я вхожу в систему}
  step %{Я попадаю на страницу "Сводка"}  
end

When /^Я пытаюсь попасть на страницу авторизации$/ do
  #noinspection RubyResolve
  visit login_path
end

Given /^Я - "([^"]*)", авторизованный в системе$/ do |role|
  @user = create_user_wfactory role # создание пользователя через фабрику
  step %Q{Я вхожу в систему}
end