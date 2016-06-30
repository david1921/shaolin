#!/bin/env ruby
# encoding: utf-8

require_relative '../../test_helper'

require 'active_model'
require File.expand_path('lib/validators/alpha_name_validator')

class AlphaNameValidator::ValidationTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Validations
    validates :first_name, alpha_name: true
  end

  setup do
    @validatable = Validatable.new
    @expected_validation_message = "Please enter the First name using the letters \"a\" to \"z\" you can also use spaces and hyphens \"-\""
  end

  should "not validate on nil" do
    @validatable.stubs(:first_name).returns(nil)
    assert @validatable.valid?, "Should allow nil"
  end

  should "only allow hyphen punctuation" do
    @validatable.stubs(:first_name).returns("P - hönix!")
    assert @validatable.invalid?, "Should not allow exclamation mark"
    assert_includes @validatable.errors[:first_name], @expected_validation_message

    @validatable.stubs(:first_name).returns("P - hönix.")
    assert @validatable.invalid?, "Should not allow period"
    assert_includes @validatable.errors[:first_name], @expected_validation_message

    @validatable.stubs(:first_name).returns("Little, Whinging?")
    assert @validatable.invalid?, "Should not allow comma or question mark"
    assert_includes @validatable.errors[:first_name], @expected_validation_message
  end

  should "only allow spaces as whitespace characters" do
    @validatable.stubs(:first_name).returns("Hello\n")
    assert @validatable.invalid?, "Should not allow newline characters"
    assert_includes @validatable.errors[:first_name], @expected_validation_message

    @validatable.stubs(:first_name).returns("Hello\t")
    assert @validatable.invalid? "Should not allow tab characters"
    assert_includes @validatable.errors[:first_name], @expected_validation_message
  end

  should "not allow leading whitespaces" do
    @validatable.stubs(:first_name).returns(" Harry")
    assert @validatable.invalid?, "Should not allow leading whitespaces"
    assert_includes @validatable.errors[:first_name], @expected_validation_message
  end

  should "allow strings with hypens, spaces, and accented characters" do
    @validatable.stubs(:first_name).returns("P - hönix")
    assert @validatable.valid?, "Should allow hyphens and spaces"
  end
end