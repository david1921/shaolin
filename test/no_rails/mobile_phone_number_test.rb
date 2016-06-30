require_relative '../test_helper'
require File.expand_path('lib/mobile_phone_number')

class MobilePhoneNumberTest < Test::Unit::TestCase

  should "allow a valid mobile phone number" do
    assert_equal 0, MobilePhoneNumber.create("07711111111").problems.size
  end

  should "not allow a number longer than 11 digits" do
    problems = MobilePhoneNumber.create("071234567890").problems
    assert_equal 1, problems.size
    assert_includes problems, :phone_mobile_invalid_length
  end

  should "not allow a number longer less than 11 digits" do
    problems = MobilePhoneNumber.create("0712345678").problems
    assert_equal 1, problems.size
    assert_includes problems, :phone_mobile_invalid_length
  end

  should "only allow numbers starting 07" do
    problems = MobilePhoneNumber.create("02711111111").problems
    assert_equal 1, problems.size
    assert_includes problems, :phone_mobile_invalid_prefix
  end

end
