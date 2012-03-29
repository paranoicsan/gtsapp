# encoding: utf-8
Given /^Я - администратор системы$/ do
  @user = create_user :admin
  @user.save_without_session_maintenance
  #noinspection RubyResolve
  visit login_path
  login @user
end
When /^Я перехожу на страницу "([^"]*)"$/ do |page|
  case page.downcase
    when 'пользователи'
      click_link 'Пользователи'
    else
      # type code here
  end
end
Then /^Я вижу надпись "([^"]*)"$/ do |text|
  page.should have_content(text)
end