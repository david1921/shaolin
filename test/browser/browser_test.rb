ENV["RAILS_ENV"] = "test"

require_relative "../../config/environment"
require_relative "lib/screenshots"
require_relative "lib/authentication_helper"
require_relative "lib/assertions"
require_relative "lib/dom_helper"

require 'rails/test_help'
require "capybara/rails"
require "capybara/webkit"
require 'database_cleaner'
require 'factory_girl'
require 'ruby-debug'
require 'capybara-screenshot'
require_relative '../factories_loader'

class BrowserTest < ActiveSupport::TestCase
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods
  include BrowserTests::Screenshots
  include BrowserTests::AuthenticationHelper
  include BrowserTests::DomHelper
  include BrowserTests::Assertions

  self.use_transactional_fixtures = false

  setup :setup_driver, :reset_session, :set_cleaner_strategy, :prevent_external_requests
  teardown :show_page_on_error, :reset_capybara_driver, :clean_database

  def set_cleaner_strategy
    DatabaseCleaner.strategy = :truncation
  end

  def clean_database
    DatabaseCleaner.clean
  end

=begin
  To use chrome, brew install chromedriver OR download the chromedriver http://code.google.com/p/chromedriver/downloads/detail?name=chromedriver_mac_19.0.1068.0.zip&can=2&q=\n
  Then mv chromedriver to /usr/local/bin
=end
  def setup_driver
    if system("which chromedriver > /dev/null 2>&1")
      Capybara.register_driver :selenium_chrome do |app|
        Capybara::Selenium::Driver.new(app, :browser => :chrome)
      end
    end

    Capybara.javascript_driver = :webkit

    if ENV["CAPYBARA_JS_DRIVER"].present?
      Capybara.javascript_driver = ENV["CAPYBARA_JS_DRIVER"].to_sym
    end

    if ENV["CAPYBARA_DRIVER"].present?
      Capybara.current_driver = ENV["CAPYBARA_DRIVER"].to_sym
    else
      Capybara.use_default_driver
    end

    Capybara.server_port = 8082
    Capybara.run_server = true
  end

  def reset_capybara_driver
    Capybara.use_default_driver
  end

  def show_page_on_error
    if ENV["SHOW_PAGE_ON_ERROR"] && !@passed
      save_and_open_page
    end
  end

  def say_if_verbose(text)
    if ENV["VERBOSE"].present?
      puts text
    end
  end

  def page_errors
    @page_errors ||= []
  end

  def current_path_with_params
    uri = URI.parse(current_url)
    "#{uri.path}?#{uri.query}"
  end

  def current_path
    uri = URI.parse(current_url)
    uri.path
  end

  def reset_session
    page.reset_session! # Selenium driver doesn't seem to be resetting cookies between tests
  end

  def require_javascript_driver!
    Capybara.current_driver = Capybara.javascript_driver
  end

  def prevent_external_requests
    FakeWeb.allow_net_connect = false
    FakeWeb.allow_net_connect = %r[^https?://(localhost|127.0.0.1)]
  end

end
