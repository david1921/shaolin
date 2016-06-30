require_relative '../../test_helper'

require 'active_model'
require File.expand_path('lib/validators/postcode_validator')
require File.expand_path('lib/postcode')

class PostcodeValidator::ValidationTest < ActiveSupport::TestCase

  class Validatable
    include ActiveModel::Validations
    validates :postcode_field, postcode: true
  end

  setup do
    @validatable = Validatable.new
  end

  should "allow nil" do
    @validatable.stubs(:postcode_field).returns nil
    assert @validatable.valid?, "Should allow nil"
  end

  should "assign errors to the record from the postcode" do
    @validatable.stubs(:postcode_field).returns "IRRELEVANT"

    problems = {
      postcode_outcode_invalid_character: "some advice",
      postcode_outcode_too_many_alpha_chars_in_district: "more advice"
    }
    postcode = stub(problems: problems)
    Postcode.stubs(:create).with("IRRELEVANT").returns(postcode)

    assert @validatable.invalid?, "Should not allow allow postcodes with problems"
    assert_equal problems.size, @validatable.errors[:postcode_field].size
  end
end
