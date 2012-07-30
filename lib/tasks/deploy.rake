# encoding: utf-8
# Пространство имён для задач по развёртыванию приложения
namespace :deploy do
  desc 'Обновляет значения версии приложения'
  task :update_version => :environment do
    File.open(ApplicationHelper::APP_VERSION_FILE, 'w') do |f|
      f.write `git describe --always`
    end
  end
end