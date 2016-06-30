#
# Purpose: Staging Seed data
# Usage: rake db:seed RAILS_ENV='staging'
#

require 'factory_girl'
include FactoryGirl::Syntax::Methods

%w( admin sales system merchant ).each do |user|
  User.find_by_username( user ) ||
    FactoryGirl.create( "#{user}_user".to_sym,
                       username: user,
                       password: "test123test",
                       password_confirmation: "test123test" )
end
