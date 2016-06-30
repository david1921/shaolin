#!/bin/env ruby
# encoding: utf-8

require_relative '../../test_helper'

require 'active_model'
require File.expand_path('lib/validators/url_validator')

class UrlValidator::ValidationTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Validations
    validates :business_website_url, url: true
  end

  setup do
    @validatable = Validatable.new
    @expected_validation_message = "Please enter a valid website address."
  end

  should "allow http and https" do
    @validatable.stubs(:business_website_url).returns("http://test.com")
    assert @validatable.valid?, "Should allow http in URLs"

    @validatable.stubs(:business_website_url).returns("https://test.com")
    assert @validatable.valid?, "Should allow https in URLs"
  end

  should "allow - in domains" do
    @validatable.stubs(:business_website_url).returns("http://te-st.com")
    assert @validatable.valid?, "Should allow - in URLs"
  end

  should "reject invalid domains" do
    @validatable.stubs(:business_website_url).returns("http://te##st.com")
    assert @validatable.invalid?, "Should not allow invalid URLs"

    @validatable.stubs(:business_website_url).returns("htp://test.com")
    assert @validatable.invalid?, "Should not allow invalid URLs"

    @validatable.stubs(:business_website_url).returns("http://te_st.com")
    assert @validatable.invalid?, "Should not allow invalid URLs"
  end

  should "accept valid domains" do
    @validatable.stubs(:business_website_url).returns("http://test.com")
    assert @validatable.valid?, "Should accept valid URLs"

    @validatable.stubs(:business_website_url).returns("http://www.test.com")
    assert @validatable.valid?, "Should accept valid URLs"

    @validatable.stubs(:business_website_url).returns("http://boo.test.com")
    assert @validatable.valid?, "Should accept valid URLs"

    @validatable.stubs(:business_website_url).returns("http://test.ly")
    assert @validatable.valid?, "Should accept valid URLs"
  end
end

