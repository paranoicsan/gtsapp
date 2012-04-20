# encoding: utf-8
When /^Я вижу сообщение "([^"]*)"$/ do |msg|
  #save_and_open_page
  page.should have_content(msg)
end
Then /^Я вижу надпись "([^"]*)"$/ do |text|
  page.should have_content(text)
end