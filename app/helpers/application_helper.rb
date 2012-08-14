module ApplicationHelper
  # Определение версии приложения
  APP_VERSION_FILE = 'config/version'
  File.open(APP_VERSION_FILE) { |f| APP_VERSION = f.readline}

  ##
  # Возвращает имя CSS класса для обработки верхнего меню в twitter bootstrap
  # @return [String] Имя CSS класса
  def top_menu_active?(path)
    request.fullpath == path ? 'active' : ''
  end
end
