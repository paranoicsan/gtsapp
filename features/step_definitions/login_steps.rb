# encoding: utf-8
Given /^Я - зарегистрированный пользователь$/ do
  username = "test_username@t.com"
  pwd = "test_password"
  params = {
      :username => username,
      :email => username,
      :password => pwd,
      :password_confirmation => pwd
  }
  @user = User.create(params)
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
  page.should have_content(msg)
end
When /^Я пытаюсь войти в систему с неверными данными$/ do
  @user = User.new
  @user.username = ""
  @user.password = ""
  step "Я вхожу в систему"
end
Given /^Я на странице авторизации$/ do
  #noinspection RubyResolve
  visit login_path
end
Then /^Я остаюсь на странице авторизации$/ do
  page.should have_content("Авторизация")
end