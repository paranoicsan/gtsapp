# Encoding: utf-8
require 'active_record'
require 'sqlite3'

ROOT = File.join(File.dirname(__FILE__), '..')

%w(/lib /db).each do |folder|
  $:.unshift File.join(ROOT, folder)
end

ActiveRecord::Base.logger = Logger.new('log/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))

namespace :db do

  def recreate_companies
    config = ActiveRecord::Base.configurations[Rails.env]    
    `sqlite3 #{config['database']} < lib/tasks/test_only/foreign_keys.sql`
  end

  desc 'Пересоздание тестовых таблиц sqlite с внешними ключами'
  task :sqlite_create_foreign_keys do
    recreate_companies
  end

end