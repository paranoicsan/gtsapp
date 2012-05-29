# Encoding: UTF-8
When /^Я выбираю рубрику "([^"]*)"$/ do |rname|
  select rname, :from => ""
end