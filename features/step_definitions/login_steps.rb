# encoding: utf-8
Given /^Я - зарегистрированный пользователь$/ do
  @user = create_user
  @user.save_without_session_maintenance # решение https://github.com/binarylogic/authlogic/issues/262
end

When /^Я вхожу в систему$/ do
  step %{Я пытаюсь попасть на страницу авторизации}
  login @user
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
  step %{Я пытаюсь попасть на страницу авторизации}
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

When /^Я пытаюсь попасть на страницу авторизации$/ do
  #noinspection RubyResolve
  visit login_path
end