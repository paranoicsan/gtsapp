module ApplicationHelper

  # Определение версии приложения
  def self.app_version
    version_file = 'config/version'
    version = ''
    File.open(version_file) { |f| version = f.readline}
    version
  end

  ##
  # Возвращает имя CSS класса для обработки верхнего меню в twitter bootstrap
  # @return [String] Имя CSS класса
  def top_menu_active?(path)
    request.fullpath == path ? 'active' : ''
  end
end
