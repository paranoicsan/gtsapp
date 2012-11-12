# encoding: utf-8
# Пространство имён для задач по развёртыванию приложения
namespace :deploy do
  desc 'Обновляет значения версии приложения'
  task :update_version => :environment do
    File.open(ApplicationHelper::APP_VERSION_FILE, 'r+') do |f|
      # получаем номер версии, который вводился вручную
      full_ver = f.readline

      # читаем последний тег
      s = `git describe --always`
      s = s.length > 0 ? s : 'Unknown'
      f.truncate(0)
      f.write "#{full_ver.gsub(/\s.*$/, '')} #{s}".gsub(/\n/, '')
    end
  end
end