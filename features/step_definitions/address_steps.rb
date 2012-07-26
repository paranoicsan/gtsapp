# encoding: utf-8
When /^Для филиала "([^"]*)" компании "([^"]*)" создаю адрес с информацией$/ do |bname, cname, table|
  # table is a |a1     |a2  |a3      |a4   |a5    |a6    |a7   |a8      |a9   |pending
  branch = find_branch(bname, cname)
  #noinspection RubyResolve
  visit branch_path branch
  click_link "Добавить адрес"
  table.hashes.each do |info|
    # |cabinet|case|entrance|house|litera|office|other|pavilion|stage|
    fill_in 'address_cabinet', :with => info[:cabinet]
    fill_in 'address_case', :with => info[:case]
    fill_in 'address_entrance', :with => info[:entrance]
    fill_in 'address_house', :with => info[:house]
    fill_in 'address_litera', :with => info[:litera]
    fill_in 'address_office', :with => info[:office]
    fill_in 'address_other', :with => info[:other]
    fill_in 'address_pavilion', :with => info[:pavilion]
    fill_in 'address_stage', :with => info[:stage]
    break
  end
  click_button "Сохранить"
end
When /^Я вижу адрес со следующей информацией$/ do |table|
  # table is a |a1     |a2  |a3      |a4   |a5    |a6    |a7   |a8      |a9   |pending
  table.hashes.each do |info|
    page.should have_content info[:cabinet]
    page.should have_content info[:case]
    page.should have_content info[:entrance]
    page.should have_content info[:house]
    page.should have_content info[:litera]
    page.should have_content info[:office]
    page.should have_content info[:other]
    page.should have_content info[:pavilion]
    page.should have_content info[:stage]
    break
  end
end
When /^Для филиала "([^"]*)" компании "([^"]*)" существует адрес$/ do |bname, cname|
  @branch = find_branch(bname, cname)
  @branch.address = Address.create({:house => 111})
end
Then /^Я не вижу ссылку "([^"]*)" на странице филиала "([^"]*)" компании "([^"]*)"$/ do |link_name, bname, cname|
  branch = find_branch(bname, cname)
  #noinspection RubyResolve
  visit branch_path branch
  page.should_not have_content link_name
end
Then /^Я удаляю адрес на странице филиала "([^"]*)" компании "([^"]*)"$/ do |bname, cname|
  branch = find_branch(bname, cname)
  #noinspection RubyResolve
  visit branch_path branch
  click_link "Удалить адрес"
end
When /^Я вижу ссылку "([^"]*)"$/ do |link_name|
  page.should have_content link_name
end
When /^Я изменяю его со следующей информацией$/ do |table|
  # table is a |a1     |a2  |a3      |a4   |a5    |a6    |a7   |a8      |a9   |pending
  #noinspection RubyResolve
  visit branch_path @branch
  click_link "Изменить адрес"
  table.hashes.each do |info|
    @edited_info = info # Сохраняем новую информацию для следующей проверки

    # |cabinet|case|entrance|house|litera|office|other|pavilion|stage|
    fill_in 'address_cabinet', :with => info[:cabinet]
    fill_in 'address_case', :with => info[:case]
    fill_in 'address_entrance', :with => info[:entrance]
    fill_in 'address_house', :with => info[:house]
    fill_in 'address_litera', :with => info[:litera]
    fill_in 'address_office', :with => info[:office]
    fill_in 'address_other', :with => info[:other]
    fill_in 'address_pavilion', :with => info[:pavilion]
    fill_in 'address_stage', :with => info[:stage]
    click_button "Сохранить"
    break
  end
end
Then /^Я вижу адрес с новой информацией$/ do
  page.should have_content "Адрес"
  page.should have_content @branch.fact_name
  @edited_info.each_value do |v|
    page.should have_content v
  end
end

When /^Я перехожу на страницу филиала$/ do
  #noinspection RubyResolve
  visit branch_path @branch
end

When /^Существуют следующие города$/ do |table|
  table.hashes.each do |row|
    City.create! :name => row[:name]
  end
end

When /^Существуют следующие улицы$/ do |table|
  table.hashes.each do |row|
    c = City.find_by_name row[:city_name]
    Street.create! name: row[:name], city_id: c.name
  end
end

When /^Существуют следующие районы$/ do |table|
  table.hashes.each do |row|
    District.create! name:row[:name]
  end
end

When /^Существует следующий адрес для филиала "([^"]*)" компании "([^"]*)"$/ do |bname, cname, table|
  b = find_branch bname, cname
  table.hashes.each do |row|
    #| city_name   | district_name | street_name | house | office | cabinet |

    params = {
        house: row[:house],
        office: row[:office],
        cabinet: row[:cabinet]
    }

    obj = City.find_by_name row[:city_name]
    params[:city_id] = obj.id if obj
    obj = District.find_by_name row[:district_name]
    params[:district_id] = obj.id if obj
    obj = Street.find_by_name row[:street_name]
    params[:street_id] = obj.id if obj

    a = Address.create params
    b.address = a
    b.save!
  end

end