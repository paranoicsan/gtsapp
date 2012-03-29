# encoding: utf-8
include ApplicationHelper

When /^Я нажимаю на ссылку "([^"]*)"$/ do |link_text|
  #save_and_open_page
  click_link link_text
end
When /^Я нахожусь на странице "([^"]*)"$/ do |title|
  page.find('h1.section-title').should have_content title
end