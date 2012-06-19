source 'https://rubygems.org'

gem 'rails', '3.2.6'

# Database
gem 'mongoid'
gem 'bson_ext'

# Views
gem 'jquery-rails'
gem "bootstrap-sass", ">= 2.0.1"

# API
gem 'rocket_pants', '~> 1.0'

group :development do
  gem 'guard-livereload'
  gem "guard-bundler"
end

group :test, :development do
  gem 'debugger'
  gem "rspec-rails", "~> 2.0"
  gem 'capistrano'
  gem 'guard'
  gem 'guard-rspec'
  gem 'mongoid-rspec'
  gem "factory_girl_rails", ">= 3.1.0"
  gem "awesome_print"
  gem "bullet"
end

group :test do
  gem "email_spec", ">= 1.2.1"
  gem "capybara", ">= 1.1.2", :group => :test
  gem "launchy", ">= 2.1.0", :group => :test
  gem "database_cleaner", ">= 0.7.2", :group => :test
  gem "guard-rails"
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'
