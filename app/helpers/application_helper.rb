module ApplicationHelper
  APP_VERSION_FILE = 'config/version'
  File.open(APP_VERSION_FILE) { |f| APP_VERSION = f.readline}
end
