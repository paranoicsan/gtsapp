# Encoding: utf-8
Then /^Я (|не) могу посмотреть коды проекта$/ do |negate|
  if negate.eql?('не')
    page.should_not have_link("Коды проекта", href: project_codes_path)
  else
    page.should have_link("Коды проекта", href: project_codes_path)
  end
end
When /^Я нахожусь на странице с кодами проекта$/ do
  @pcode = FactoryGirl.create :project_code
  visit project_codes_path
end
Then /^Я  могу добавить код проекта$/ do
  page.should have_link('Добавить', href: new_project_code_path)
end
Then /^Я  могу изменить код проекта$/ do
  page.should have_link('Изменить', href: edit_project_code_path(@pcode))
end
Then /^Я  могу удалить код проекта$/ do
  page.should have_link('Удалить', href: project_code_path(@pcode), method: 'delete')
end