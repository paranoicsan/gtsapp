module ApplicationHelper
  # Определение версии приложения
  APP_VERSION_FILE = 'config/version'
  File.open(APP_VERSION_FILE) { |f| APP_VERSION = f.readline}

  def top_menu_active?(path)
    puts path
    puts request.url
    request.fullpath == path ? 'active' : ''
  end
end
