require_relative '../test_helper'
require File.expand_path('lib/landline_phone_number')

class LandlinePhoneNumberTest < Test::Unit::TestCase

  should "allow a valid eleven digit number" do
    assert_equal 0, LandlinePhoneNumber.create("01211111111").problems.size
  end

  should "allow a valid ten digit number" do
    assert_equal 0, LandlinePhoneNumber.create("0121111111").problems.size
  end

  should "not allow a number longer than 11 digits" do
    problems = LandlinePhoneNumber.create("012111111111").problems
    assert_equal 1, problems.size
    assert_includes problems, :phone_landline_invalid_length
  end

  should "not allow a number longer less than 10 digits" do
    problems = LandlinePhoneNumber.create("012111111").problems
    assert_equal 1, problems.size
    assert_includes problems, :phone_landline_invalid_length
  end

  should "not allow numbers with invalid prefixes" do
    %W[04 05 06 09].each do |invalid_prefix|
      problems = LandlinePhoneNumber.create("#{invalid_prefix}11111111").problems
      assert_equal 1, problems.size, "The prefix #{invalid_prefix} should be invalid"
      assert_includes problems, :phone_landline_invalid_prefix, "The prefix #{invalid_prefix} should be invalid"
    end
  end

  should "allow numbers with valid prefixes" do
    %W[01 02 03 07 08].each do |valid_prefix|
      problems = LandlinePhoneNumber.create("#{valid_prefix}11111111").problems
      assert_equal 0, problems.size, "The prefix #{valid_prefix} should be valid"
    end
  end

end
