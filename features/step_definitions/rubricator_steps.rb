# Encoding: UTF-8
When /^Я выбираю рубрику "([^"]*)"$/ do |rname|
  select rname, :from => "select_rubrics"
end

When /^Существуют следующие рубрики$/ do |table|
  table.hashes.each do |row|
    Rubric.create! :name => row[:name], :social => row[:social]
  end
end

When /^Компания "([^"]*)" входит в следующие рубрики$/ do |cname, table|
  company = Company.find_by_title cname
  table.hashes.each do |r|
    rub = Rubric.find_by_name r[:name]
    company.rubrics << rub
  end
end

Then /^Я вижу таблицу "([^"]*)" с рубриками$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    within :xpath, xpth do
      row_xpth = "//tr[#{idx}]/td[1]"
      find(:xpath, row_xpth).text.should == row[:name]
    end
    idx += 1
  end
end

Then /^Я вижу "([^"]*)" в ряду (\d+) таблице "([^"]*)"$/ do |rub_name, row_num, table_id|
  within :xpath, "//table[@id='#{table_id}']" do
    find(:xpath, "//tr[#{row_num}]/td[1]").text.should == rub_name
  end
end