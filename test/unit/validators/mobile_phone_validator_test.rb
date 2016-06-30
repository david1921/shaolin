require_relative '../../test_helper'

require 'active_model'
require File.expand_path('lib/validators/mobile_phone_validator')
require File.expand_path('lib/mobile_phone_number')

class MobilePhoneValidator::ValidationTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Validations
    validates :mobile, mobile_phone: true
  end

  setup do
    @validatable = Validatable.new
  end

  should "not validate on nil" do
    @validatable = Validatable.new
    @validatable.stubs(:mobile).returns nil

    assert @validatable.valid?, "Should allow nil"
  end

  context "with invalid mobile phone numbers" do
    should "add problems to the record's validation errors" do
      @validatable.stubs(:mobile).returns("1234irrelevant")

      problem_advice = { 
        phone_mobile_invalid_length: "irrelevant",
        phone_mobile_invalid_prefix: "irrelevant"
      }
      mobile_phone_number = stub(problems: problem_advice)
      MobilePhoneNumber.stubs(:create).with("1234irrelevant").returns(mobile_phone_number)

      assert @validatable.invalid?, "should be invalid when problems with the number"
      assert_equal problem_advice.size, @validatable.errors[:mobile].size
    end
  end
end 
