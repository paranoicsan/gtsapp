# encoding: utf-8
require 'rubygems'
require 'spork'
require 'factory_girl'
require 'selenium-webdriver'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  require 'cucumber/rails'

  ActionController::Base.asset_host = Capybara.app_host


  ActionController::Base.allow_rescue = false

  begin
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  rescue NameError
    raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
  end

  #Cucumber::Rails::Database.javascript_strategy = :transaction
  Cucumber::Rails::Database.javascript_strategy = :truncation

  Capybara.register_driver :selenium do |app|
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 240
    Capybara::Selenium::Driver.new(app,
                                   :browser => :chrome,
                                   :http_client => client)
                                   #:resynchronization_timeout => 60,
                                   #:resynchronize => true)
  end
  Capybara.javascript_driver = :selenium


end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  DatabaseCleaner.clean_with :truncation
  FactoryGirl.reload
end