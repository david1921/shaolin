require_relative '../test_helper'

class AddressTest < ActiveSupport::TestCase
  context "validations" do
    should_validate_attribute_with_validator(Address, :postcode, PostcodeValidator)
  end

  context "#to_s" do
    should "concatenate available addresses with post town and postcode" do
      address = create(:address, address_line_1: 'A1', address_line_2: 'A2', address_line_3: '', address_line_5: 'A5', post_town: 'London', postcode: 'AA99 9AA')
      assert_equal 'A1, A2, A5 London AA99 9AA', address.to_s
    end
  end
end
