# encoding: utf-8
require 'csv'
namespace :db do

  desc 'Загрузка Формы собственности'
  task :load_form_types  => :environment do
    CSV.foreach('db/data/form_type.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      FormType.create(:old_id => row[0], :name => row[1])
    end
  end

  desc 'Загрузка Городов'
  task :load_cities  => :environment do
    CSV.foreach('db/data/city.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      City.create(:old_id => row[0], :name => row[1], :phone_code =>row[2])
    end
  end

  desc 'Загрузка Районов'
  task :load_districts  => :environment do
    CSV.foreach('db/data/district.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      District.create(:old_id => row[0], :name => row[1])
    end
  end

  desc 'Загрузка Почтовых индексов'
  task :load_post_indexes  => :environment do
    CSV.foreach('db/data/post_indexes.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      PostIndex.create(:old_id => row[0], :code => row[1])
    end
  end

  desc 'Загрузка Улиц'
  task :load_streets  => :environment do
    CSV.foreach('db/data/street.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|

      old_city_id = row[2] # старый ключ города
      new_city_id = City.find_by_old_id(old_city_id).id # определяем новый

      Street.create(:old_id => row[0], :name => row[1], :city_id => new_city_id)
    end
  end

end