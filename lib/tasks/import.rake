# encoding: utf-8
require 'csv'

namespace :db do

  def form_types
    CSV.foreach('db/data/form_type.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      FormType.create(:old_id => row[0], :name => row[1])
    end  
  end

  def cities
    CSV.foreach('db/data/city.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      City.create(:old_id => row[0], :name => row[1], :phone_code => row[2])
    end
  end

  def districts
    CSV.foreach('db/data/district.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      District.create(:old_id => row[0], :name => row[1])
    end
  end

  def post_indexes
    CSV.foreach('db/data/post_indexes.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      PostIndex.create(:old_id => row[0], :code => row[1])
    end
  end

  def streets
    CSV.foreach('db/data/street.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_city_id = row[2] # старый ключ города
      new_city_id = City.find_by_old_id(old_city_id).id # определяем новый

      Street.create(:old_id => row[0], :name => row[1], :city_id => new_city_id)
    end
  end

  def street_indexes
    CSV.foreach('db/data/street_index.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_street_id = row[0]
      old_index_id = row[1]
      new_street_id = Street.find_by_old_id(old_street_id).id
      new_index_id = PostIndex.find_by_old_id(old_index_id).id

      StreetIndex.create(:street_id => new_street_id, :post_index_id => new_index_id,
                         :comments => row[2])
    end
  end

  def rubrics
    # коммерческие рубрики
    #CSV.foreach('db/data/rubrics.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
    #  Rubric.create(:old_id => row[0], :name => row[1], :social => false)
    #end
    CSV.foreach('db/data/rubric_keywords.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      kw = Keyword.create(:name => row[2])
      kw.save
      rub = Rubric.find_by_old_id row[1]
      RubricKeyword.create(:rubric_id => rub.id, :keyword_id => kw.id)
    end

    # социальные
    #CSV.foreach('db/data/soc_rubrics.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
    #  Rubric.create(:old_id => row[0], :name => row[1], :social => true)
    #end
    CSV.foreach('db/data/soc_rubric_keywords.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      kw = Keyword.create(:name => row[2])
      kw.save
      rub = Rubric.find_by_old_id row[1]
      RubricKeyword.create(:rubric_id => rub.id, :keyword_id => kw.id)
    end
  end

  desc 'Полная загрузка'
  task :load_all_data => :environment do
    form_types
    cities
    districts
    post_indexes
    streets
    street_indexes
    rubrics
  end
  
  desc 'Загрузка Формы собственности'
  task :load_form_types  => :environment do
    form_types  
  end

  desc 'Загрузка Городов'
  task :load_cities  => :environment do
    cities
  end

  desc 'Загрузка Районов'
  task :load_districts  => :environment do
    districts
  end

  desc 'Загрузка Почтовых индексов'
  task :load_post_indexes  => :environment do
    post_indexes
  end

  desc 'Загрузка Улиц'
  task :load_streets  => :environment do
    streets
  end

  desc 'Загрузка связей Улица-Почтовый индекс'
  task :load_streets_indices  => :environment do
    street_indexes
  end

  desc 'Рубрик'
  task :load_rubrics  => :environment do
    rubrics
  end
end