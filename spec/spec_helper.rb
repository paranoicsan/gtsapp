# encoding: utf-8
require 'rubygems'
require 'spork'
require 'factory_girl'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

# This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  require 'shared/auth_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
#noinspection RubyResolve
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Загружаем фабрики
  Dir.glob(File.dirname(__FILE__) + "/factories/*").each do |factory|
    #noinspection RubyResolve
    require factory
  end

  RSpec.configure do |config|

    config.include AuthHelper


    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    #noinspection RubyResolve
    config.infer_base_class_for_anonymous_controllers = true

    # разрешаем использование миксованного синтаксиса
    #config.include FactoryGirl::Syntax::Methods

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      #DatabaseCleaner.clean_with :transaction
      DatabaseCleaner.clean_with :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:all) do
      DatabaseCleaner.clean_with(:truncation)
    end

  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  DatabaseCleaner.clean_with :truncation

end

