source 'http://rubygems.org'

gem 'rails', '3.2.12'

gem 'pg'
gem 'foreigner'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'authlogic'
gem 'easy_roles'
gem 'will_paginate'
gem 'twitter-bootstrap-rails', '~> 2.1.4'
gem 'bootstrap-will_paginate', '0.0.7'
gem 'jquery-ui-rails'
gem 'rails3-jquery-autocomplete'
gem 'unicode_utils'
gem 'russian', '~> 0.6.0'

# report generators
gem 'prawn' # PDF
gem 'rtf' # RTF
gem 'spreadsheet' # Excel

group :development, :test do
  gem 'simplecov', :require => false
  gem 'faker'
  gem 'database_cleaner'
  gem 'rspec-rails', '>= 2.12.2'
  gem 'factory_girl_rails'
  gem 'spork'
  gem 'rb-readline'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'launchy'
  gem 'chromedriver-helper'
  gem 'debugger', '1.2.1', :require => 'ruby-debug'

  # Contains hack for foreigner and pg to work together
  gem 'rails3_pg_deferred_constraints', '~> 0.1.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
end
