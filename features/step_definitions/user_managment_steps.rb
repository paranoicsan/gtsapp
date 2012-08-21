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
  @user = find_user username
  #noinspection RubyResolve
  visit login_path
  login @user, pwd
end
When /^Я удаляю пользователя "([^"]*)"$/ do |username|
  step %{Я нахожусь на странице "Пользователи"}
  user = find_user username
  #noinspection RubyResolve
  s = user_path(user)
  page.find(%{a[href = "#{s}"]}).click
end
When /^Я не вижу пользователя "([^"]*)"$/ do |username|
  page.should_not have_content username
end
When /^Я создаю нового пользователя$/ do
  #noinspection RubyResolve
  visit new_user_path
  fill_in "user_username", :with => 'Test user'
  fill_in "user_password", :with => '1111'
  fill_in "user_password_confirmation", :with => '1111'
  fill_in "user_email", :with => 'test@333test.com'
  click_button "Создать"
end
When /^Пользователь "([^"]*)" связан с существующей компанией$/ do |username|
  user = find_user username
  FactoryGirl.create :company, editor: user
end
Then /^Я не могу удалить самого себя$/ do
  page.should_not have_link('Удалить', href: user_path(@user), :method => 'delete')
end