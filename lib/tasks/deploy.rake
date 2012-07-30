# encoding: utf-8
# Пространство имён для задач по развёртыванию приложения
namespace :deploy do
  desc 'Обновляет значения версии приложения'
  task :update_version => :environment do
    File.open(ApplicationHelper::APP_VERSION_FILE, 'w') do |f|
      s = `git describe --always`
      s = s.length > 0 ? s : 'Unknown'
      f.write s
    end
  end
end