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

end