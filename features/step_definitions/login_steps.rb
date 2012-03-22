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
  #@user = User.find_by_email(username = "test_username@t.com")
  #noinspection RubyResolve
  visit login_path
  fill_in "user_session_username", :with => @user.username
  fill_in "user_session_password", :with => @user.password
  click_button "login_bt"
end
Then /^Я попадаю на страницу "([^"]*)"$/ do |page_title|
  page.should have_content(page_title)
end
When /^Я должен увидеть сообщение "([^"]*)"$/ do |msg|
  page.should have_content(msg)
end