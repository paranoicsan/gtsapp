source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'pg'
gem 'foreigner'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'authlogic'
gem 'easy_roles'
gem 'will_paginate'
gem 'twitter-bootstrap-rails'
gem 'jquery-ui-rails'
gem 'rails3-jquery-autocomplete'

group :development, :test do
  gem 'debugger', :require => 'ruby-debug'
  gem 'simplecov', :require => false
  gem 'rspec'
  gem 'rspec-rails'
  gem 'spork'
  gem 'factory_girl_rails', :require => false
end

group :test do
  gem 'sqlite3'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'chromedriver-helper'

end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'uglifier'
  gem 'bootstrap-will_paginate'
end

group :test, :assets do
  gem 'coffee-rails', "~> 3.1.0"
end