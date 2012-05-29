# Encoding: UTF-8
When /^Я выбираю рубрику "([^"]*)"$/ do |rname|
  select rname, :from => "select_rubrics"
end

When /^Существуют следующие рубрики$/ do |table|
  table.hashes.each do |row|
    Rubric.create! :name => row[:name], :social => row[:social]
  end
end

Then /^Я вижу "([^"]*)" в таблице "([^"]*)"$/ do |rub_name, table_id|
  xpth = "//table[@id='#{table_id}']/tr[1]"
  within :xpath, xpth do
    find(:xpath, "//td[1]").text.should == rub_name
  end
end