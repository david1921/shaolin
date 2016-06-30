# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MerchantPortal::Application.initialize!

unless Rails.env.production? || Rails.env.test? || defined?(FactoryGirl)
  require 'factory_girl'
  require Rails.root.join('test/factories')
end
