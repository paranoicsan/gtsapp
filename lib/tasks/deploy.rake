# encoding: utf-8
# Пространство имён для задач по развёртыванию приложения
namespace :deploy do
  desc 'Обновляет значения версии приложения'
  task :update_version => :environment do

    # TODO: Переписать на новый формат хранения версии
    #f = File.open(ApplicationHelper::APP_VERSION_FILE, 'r+')
    #
    ## получаем номер версии, который вводился вручную
    #full_ver = f.readline.gsub(/\s.*$/, '')
    #
    ## читаем последний тег
    #s = `git describe --abbrev=0 --tags`
    #s = s.length > 0 ? s : 'Unknown'
    #f.rewind
    #f.puts ""
    #f.rewind
    #f.puts "#{full_ver} #{s}".gsub(/\n/, '')
    #f.close
  end
end