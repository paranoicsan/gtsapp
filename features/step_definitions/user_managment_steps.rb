# encoding: utf-8
Given /^Я - администратор системы$/ do
  @user = create_user
  @user.save_without_session_maintenance
  #noinspection RubyResolve
  @user.add_role "admin"
  @user.save
  #noinspection RubyResolve
  visit login_path
  login @user
end
Then /^Я вижу список пользователей$/ do
  #save_and_open_page
  page.find("h1.section-title").should have_content "Пользователи"
end
Given /^Я - не администратор системы$/ do
  @user = create_user
  @user.save_without_session_maintenance
  #noinspection RubyResolve
  @user.add_role "operator"
  @user.save
  #noinspection RubyResolve
  visit login_path
  login @user
end