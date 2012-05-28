When /^Я выбираю рубрику "([^"]*)"$/ do |rname|
  select rname, :from => ""
end