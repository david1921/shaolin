require 'factory_girl'
include FactoryGirl::Syntax::Methods

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Purpose: Production Seed Data
# Usage:   rake db:seed - Loads the seed data from db/seeds.rb,
#                                                   db/seeds/*.seeds.rb
#
# Env: RAILS_ENV=production
# Docs: https://github.com/james2m/seedbank#readme or run rake --tasks
#
User.find_by_username("system") || User.create(
  :username => "system",
  :first_name => "System",
  :last_name => "User",
  :email => "system@system.com",
  :password => "test123test",
  :password_confirmation => "test123test",
  :active => true,
  :is_system => true,
  :is_admin => true
)
