# encoding: utf-8
include ApplicationHelper

When /^Я нажимаю на ссылку "([^"]*)"$/ do |link_text|
  click_link link_text
end
When /^Я нахожусь на странице "([^"]*)"$/ do |title|
  page.find('h1.section-title').should have_content title
end
Then /^Я не вижу ссылки "([^"]*)"$/ do |title|
  #save_and_open_page
  page.all('a').each do |link|
    if link.text.eql?(title)
      assert false, 'Ссылка видна на странице.'
    end
  end
end