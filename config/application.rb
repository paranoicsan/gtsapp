#Encoding: utf-8
require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Gtsapp
  class Application < Rails::Application
    config.i18n.default_locale = :ru

    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # подставляем пути с отчётами
    config.autoload_paths << 'lib/reports'

    config.generators do |g|
      #Здесь я отключил генерацию rspec файлов для вьюх, хелперов, роутинга и запросов
      #т.о. оставив лишь генерацию spec's для моделей и контроллеров
      g.test_framework :rspec, :view_specs => false, :helper_specs => false, :routing_specs => false,
                       :request_specs => false, :fixture_replacement => :factory_girl
      g.template_engine :haml
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  end
end
