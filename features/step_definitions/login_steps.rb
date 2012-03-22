# encoding: utf-8
Given /^Я на странице авторизации$/ do
  visit "/"
end
When /^Я заполняю "([^"]*)" значением "([^"]*)"$/ do |field, value|
  fill_in field, :with => value
end
Then /^Я должен увидеть "([^"]*)"$/ do |value|
  assert page.has_content?(value)
end