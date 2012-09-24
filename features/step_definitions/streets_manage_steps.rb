# Encoding: utf-8
When /^Я (|не) вижу список улиц$/ do |negate|
  sel = "table#streets"
  if negate.eql?('не')
    page.should_not have_selector(sel)
  else
    page.should have_selector(sel)
  end
end
When /^Я выбираю населённый пункт$/ do
  step %Q{Я выбираю "#{@city.name}" из элемента "city_id"}
  click_button "Показать"
end