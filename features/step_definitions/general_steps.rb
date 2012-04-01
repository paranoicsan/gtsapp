# encoding: utf-8
When /^Я вижу сообщение "([^"]*)"$/ do |msg|
  #save_and_open_page
  page.should have_content(msg)
end
