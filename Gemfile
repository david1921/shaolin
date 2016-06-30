source 'https://rubygems.org'

gem 'rails', '~> 3.2.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'rb-readline'


gem 'mysql2'
gem 'uuid', '~> 2.3.5'
gem 'valid_email', '~> 0.0.4'
gem 'vestal_versions', git: "git://github.com/geothird/vestal_versions.git"

gem 'simple_form', '~> 2.0'
gem 'selective_validation', '~> 0.0.3', git: "git://github.com/analog-analytics/selective_validation.git"
gem 'i18n_option_helpers', '~> 0.0.1', git: "git://github.com/analog-analytics/i18n_option_helpers.git"
gem 'bespoke_contact_validation', '~> 0.0.3', git: "git://github.com/analog-analytics/bespoke_contact_validation.git"
gem 'money-rails', '~> 0.6.0', git: "git://github.com/RubyMoney/money-rails.git"
gem 'date_validator', '0.6.3', git: "git://github.com/codegram/date_validator.git"
gem 'clearance', git: 'git://github.com/analog-analytics/clearance.git'
gem 'will_paginate'
gem 'paf', git: "git@github.com:analog-analytics/paf.git"
gem 'factory_girl_rails', '~> 3.6.0', require: false
gem 'paperclip'
gem 'aws-sdk', '~> 1.3.4'
gem 'acts_as_list'
gem 'rb-fsevent', '~> 0.9.1'
gem 'rails-i18n'
gem 'will-paginate-i18n'

gem 'encryptor', git: 'git://github.com/analog-analytics/encryptor.git'
gem 'attr_encrypted', git: 'git://github.com/analog-analytics/attr_encrypted.git'

## Seed file management ##
gem "seedbank"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '~> 1.0.3'
end

group :test do
  gem 'sqlite3', '~> 1.3.6'
  gem 'mocha', '~> 0.12.1', require: false
  gem 'spork-rails', '~> 3.2.0'
  gem 'spork-testunit', '~> 0.0.8'
  gem 'shoulda-context', '~> 1.0.0'
  gem 'guard-spork', '~> 1.1.0'
  gem 'timecop', '~> 0.3.4'
  gem 'fakeweb'
  gem 'testrbl'
  gem 'capybara', '~> 1.1.2'
  gem 'capybara-webkit', '~> 0.12.1'
  gem 'database_cleaner', '~> 0.8.0'
  gem 'capybara-screenshot', '0.2.2'
  gem 'launchy', '~> 2.1.1'
  gem 'nokogiri'
end

gem 'jquery-rails', '~> 2.0.2'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'
gem 'red_unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :development do
  gem 'debugger'
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
end

group :production do
  # therubyracer is the javascript runtime required by execjs
  # see :assets above. not sure if we should use that one or this one
  # This one was recommended in the rails-guide
  gem 'therubyracer'
end
