# Encoding: utf-8
Then /^Я вижу список персон$/ do

  # составляем ряды для таблицы
  rows = ""
  @company.persons.each do |p|
    rows = "#{rows}\n|#{p.position}|#{p.full_name}|#{p.phone}|#{p.email}|"
  end

  steps %Q{
    When Я вижу таблицу "people" с персонами
      | position | full_name | phone | email |
      #{rows}
  }
end