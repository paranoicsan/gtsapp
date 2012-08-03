# encoding: UTF-8
include ApplicationHelper

When /^Я нажимаю на ссылку "([^"]*)"$/ do |link_text|
  assert find_link(link_text).visible?, "Ссылка не видна."
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
    when "Компании"
      #noinspection RubyResolve
      visit companies_path
    when "Поиск"
      #noinspection RubyResolve
      visit search_path
    else
      assert false, "Неизвестный путь."
  end
  page.find("#{selector}").should have_content title
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
  page.should_not have_content(title), "Ссылка видна на странице."
end

Then /^Я попадаю на страницу "([^"]*)"$/ do |page_title|
  page.should have_content(page_title)
end

Then /^Я нахожусь на странице договора с номером "([^"]*)"$/ do |contract_number|
  #noinspection RubyResolve
  c = Contract.find_by_number contract_number
  #noinspection RubyResolve
  current_path.should == contract_path(c)
end

When /^Я перехожу на страницу договора "([^"]*)"$/ do |contract_number|
  c = Contract.find_by_number contract_number
  #noinspection RubyResolve
  visit contract_path(c)
end

When /^Я нажимаю на кнопку с именем "([^"]*)"$/ do |button_text|
  click_button button_text
end