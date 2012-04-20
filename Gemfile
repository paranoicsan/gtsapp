source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'pg'
gem 'foreigner'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'authlogic'
gem 'easy_roles'

group :production do
  gem 'taps'
end

group :development, :test do
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'simplecov', :require => false
  gem 'rspec'
  gem 'rspec-rails'
  gem 'spork'
end

group :test do
  gem 'sqlite3'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'therubyracer'
end