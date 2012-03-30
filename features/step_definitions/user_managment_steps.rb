# encoding: utf-8
Given /^Существуют следующие пользователи$/ do |table|
  # table is a | t_admin    | 1111     | t_admin@test.com    | admin    |
  table.hashes.each do |u|
    params = {
        :username => u[:username],
        :email => u[:email],
        :password => u[:password],
        :password_confirmation => u[:password]
    }
    user = User.new(params)
    #noinspection RubyResolve
    user.add_role u[:roles]
    user.save_without_session_maintenance
  end
end
Given /^Я - пользователь "([^"]*)" с паролем "([^"]*)"$/ do |username, pwd|
  @user = User.find_by_username username
  #noinspection RubyResolve
  visit login_path
  login @user, pwd
end
When /^Я удаляю пользователя "([^"]*)"$/ do |username|
  step %{Я нахожусь на странице "Пользователи"}
  user = User.find_by_username username
  #noinspection RubyResolve
  s = user_path(user)
  #page.driver.browser.switch_to.alert.accept # заранее подтверждаем диалог с вопросом
  page.find(%{a[href = "#{s}"]}).click
end
When /^Я не вижу пользователя "([^"]*)"$/ do |username|
  page.should_not have_content username
end
When /^Я создаю нового пользователя$/ do
  #noinspection RubyResolve
  visit new_user_path
  fill_in :username, :with => 'Test user'
  fill_in :password, :with => '1111'
  fill_in :password_confirmation, :with => '1111'
  fill_in :email, :with => 'test@333test.com'
  click "commit"
end