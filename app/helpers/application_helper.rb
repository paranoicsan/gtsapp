module ApplicationHelper

  VERSION_FILE = 'config/version'

  # Определение версии приложения
  def app_version
    version = ''
    File.open(VERSION_FILE) { |f| version = f.readline}
    version
  end

  ##
  # Возвращает имя CSS класса для обработки верхнего меню в twitter bootstrap
  # @return [String] Имя CSS класса
  def top_menu_active?(path)
    request.fullpath == path ? 'active' : ''
  end
end
