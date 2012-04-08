# encoding: utf-8
include ApplicationHelper

When /^Я нажимаю на ссылку "([^"]*)"$/ do |link_text|
  click_link link_text
end

When /^Я нахожусь на странице "([^"]*)"$/ do |title|
  selector = "h1" # идентификатор, по которому ищется объект для проверки
  case title
    when "Авторизация"
      #noinspection RubyResolve
      visit login_path
      selector = "div"
    when "Сводка"
      #noinspection RubyResolve
      visit dashboard_path
    when "Пользователи"
      #noinspection RubyResolve
      visit users_path
    else
      assert false, "Неизвестный путь."
  end
  page.find("#{selector}.section-title").should have_content title
end

When /^Я перехожу на страницу "([^"]*)"$/ do |title|
  case title
    when "Авторизация"
      #noinspection RubyResolve
      visit login_path
    when "Сводка"
      #noinspection RubyResolve
      visit dashboard_path
    when "Пользователи"
      #noinspection RubyResolve
      visit users_path
    when "Компании"
      #noinspection RubyResolve
      visit companies_path
    else
      assert false, "Неизвестный путь."
  end
end

Then /^Я не вижу ссылки "([^"]*)"$/ do |title|
  page.all("a").each do |link|
    if link.text.eql?(title)
      assert false, "Ссылка видна на странице."
    end
  end
end

Then /^Я попадаю на страницу "([^"]*)"$/ do |page_title|
  page.should have_content(page_title)
end