source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# PostgreSQL for ActiveRecord database
gem 'pg'
# Use Mongoid for database
gem 'mongoid', '~> 6.0'
# Use bson_ext to accelerate Ruby BSON serialization
gem 'bson_ext'
# Use HAML for HTML
gem 'haml-rails', '~> 1'
# Use Devise for user authentication
gem 'devise'
# For encryption
gem 'openssl', git: 'https://github.com/ruby/openssl'
# AWS SDK
gem 'aws-sdk'
gem 'aws-sdk-rails'
gem 'aws-sdk-s3', '~> 1'
# Date validator for models
gem 'validates_timeliness', '~> 4.0', '>= 4.0.2'
gem 'jquery-rails'
gem 'awesome_print'
gem 'simple_form'
gem 'semantic-ui-sass'
gem 'bulma-rails', '~> 0.7.4'
gem 'httplog'
gem 'shog'
gem 'enumerize'
gem 'country_select', '~> 4.0', require: 'country_select_without_sort_alphabetical'

# For PDF generation
gem 'wicked_pdf'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'solargraph'
  gem 'ruby-debug-ide'
  gem 'debase'
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.0'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.4.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

group :staging, :production do
  gem 'wkhtmltopdf-heroku'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby "2.5.1"