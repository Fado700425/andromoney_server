source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'mysql2', '~> 0.3.18'
gem 'bundler', '>= 1.8.4'

gem 'bootstrap-sass'
gem 'capistrano-bundler' # for capistrano/bundler
gem 'capistrano-rails','~> 1.1.0'# for capistrano/rails/*
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-bower','~> 1.1.0'

gem 'bootstrap-sass-rails'
gem 'bootstrap-datepicker-rails', :require => 'bootstrap-datepicker-rails',
                              :git => 'git://github.com/Nerian/bootstrap-datepicker-rails.git'

gem 'fancybox-rails', :github => 'greinacker/fancybox-rails', :branch => 'rails4'

gem 'omniauth-google-oauth2'

gem 'haml-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'figaro'
gem 'bower-rails', '~> 0.10.0'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
# gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'
gem 'will_paginate'
gem 'rails-asset-localization', git: 'git@github.com:nicolai86/rails-asset-localization.git', branch: :master

gem 'cells', "~> 4.0.0"
gem 'cells-haml'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'js-routes'
gem 'font-awesome-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'pry-rails'
  gem 'letter_opener'
  gem 'launchy'
  gem 'guard-livereload'
  gem 'rails-erd'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara-email'
  gem 'capistrano-local-precompile', require: false
end

group :test do
  gem 'sqlite3'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock', '1.15.0'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end
