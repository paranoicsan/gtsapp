# encoding: utf-8
require 'csv'
namespace :db do

  desc 'Загрузка'
  task :load_form_types  => :environment do
    CSV.foreach('db/data/form_type.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      FormType.create(:old_id => row[0], :name => row[1])
    end
  end

end