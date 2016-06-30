require_relative '../../test_helper'

require 'active_model'
require File.expand_path('lib/validators/landline_phone_validator')
require File.expand_path('lib/landline_phone_number')

class LandlinePhoneValidator::ValidationTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Validations
    validates :landline, landline_phone: true
  end

  setup do
    @validatable = Validatable.new
  end

  should "not validate on nil" do
    @validatable = Validatable.new
    @validatable.stubs(:landline).returns nil

    assert @validatable.valid?, "Should allow nil"
  end

  context "with invalid landline phone numbers" do
    should "add problems to the record's validation errors" do
      @validatable.stubs(:landline).returns("1234irrelevant")

      problem_advice = { 
        phone_landline_invalid_length: "irrelevant",
        phone_landline_invalid_prefix: "irrelevant"
      }
      mobile_phone_number = stub(problems: problem_advice)
      LandlinePhoneNumber.stubs(:create).with("1234irrelevant").returns(mobile_phone_number)

      assert @validatable.invalid?, "should be invalid when problems with the number"
      assert_equal problem_advice.size, @validatable.errors[:landline].size
    end
  end
end 
