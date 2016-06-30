require 'rubygems'
require 'spork'
require 'paperclip/matchers'
require 'ruby-debug'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # NOTE: This file loads the complete rails stack.  Started work on loading only
  # specific bits of rails for tests, see #{Rails.root}/test/test_helpers.
  #
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'
  require 'factory_girl'
  require_relative 'factories_loader'
  require 'clearance/testing'

  module FakeWeb
    class StubSocket
      def read_timeout=(ignored)
      end
    end
  end

  Dir[File.dirname(__FILE__) + '/shoulda_macros/*.rb'].each {|file| require file }

  class ActiveSupport::TestCase
    include FactoryGirl::Syntax::Methods
    extend Paperclip::Shoulda::Matchers

    setup do
      FakeWeb.allow_net_connect = false
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end

    def verify_attribute_validated_with_validator(klass, attribute, validator_class, options={})
      excluded_options = [:if, :unless]

      validator = klass.validators_on(attribute).detect { |v| v.class == validator_class}
      assert validator.present?, "#{validator_class} not used on #{attribute}"
      validator_options = {}
      validator.options.each { |key, value| validator_options[key] = value unless excluded_options.include?(key) } # exclude checks for conditionals
      assert_equal options, validator_options, "#{validator_class} does not have the options"
    end

    def exclusive_attributes_for(factory)
      parent = FactoryGirl.factories.find(factory).try(:parent)
      if parent && !parent.is_a?(FactoryGirl::NullFactory)
        parent_attributes = attributes_for(parent.name) 
        attributes_for(factory).reject { |a| parent_attributes.key?(a) } if parent_attributes
      else
        attributes_for(factory)
      end
    end

  end

  class Test::Unit::TestCase
    def assert_valid(thing)
      assert thing.valid?, "#{thing.class.name} should be valid, but has errors: #{thing.errors.full_messages}"
    end

    def assert_invalid(thing, text = nil)
      assert thing.invalid?, "#{thing.class.name} should not be valid#{' ' + text if text}"
    end
  end

# turn of migration output
  ActiveRecord::Migration.verbose = false
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

require "mocha"
# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.
