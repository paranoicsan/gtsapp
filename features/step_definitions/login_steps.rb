# encoding: utf-8
# TODO: вынести шаг авторизации в отдельный модуль
Given /^Я - зарегистрированный пользователь$/ do
  username = "test_username@t.com"
  pwd = "test_password"
  params = {
      :username => username,
      :email => username,
      :password => pwd,
      :password_confirmation => pwd
  }
  @user = User.new(params)
  @user.save_without_session_maintenance # решение https://github.com/binarylogic/authlogic/issues/262
end
When /^Я вхожу в систему$/ do
  #noinspection RubyResolve
  visit login_path
  fill_in "user_session_username", :with => @user.username
  fill_in "user_session_password", :with => @user.password
  click_button "login_bt"
end
Then /^Я попадаю на страницу "([^"]*)"$/ do |page_title|
  page.should have_content(page_title)
end
When /^Я вижу сообщение "([^"]*)"$/ do |msg|
  #save_and_open_page
  page.should have_content(msg)
end
When /^Я пытаюсь войти в систему с неверными данными$/ do
  @user = User.new
  @user.username = ""
  @user.password = ""
  step "Я вхожу в систему"
end
Given /^Я нахожусь на странице авторизации$/ do
  #noinspection RubyResolve
  visit login_path
  step %{Я остаюсь на странице авторизации} # если пользователь не вышел, он не останется на первой странице
end
Then /^Я остаюсь на странице авторизации$/ do
  page.should have_content("Авторизация")
end
Given /^Я авторизован в системе$/ do
  step %{Я - зарегистрированный пользователь}
  step %{Я вхожу в систему}
  step %{Я попадаю на страницу "Сводка"}  
end
When /^Я нажимаю на ссылку "([^"]*)"$/ do |link_text|
  click_link link_text
end