# encoding: utf-8
Given /^Я на главной странице$/ do
  visit "/"
end
When /^Я заполняю "([^"]*)" значением "([^"]*)"$/ do |arg1, arg2|
  fill_in arg1, :with => arg2
end
Then /^Я должен увидеть "([^"]*)"$/ do |arg|
  assert page.has_content?(arg)
end