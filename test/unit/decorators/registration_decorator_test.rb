require_relative '../../test_helper'

class RegistrationDecoratorTest < ActiveSupport::TestCase

  context "#current_step" do
    should "return :gross_annual_turnover when on gross annual turnover step" do
      registration_gross_annual = RegistrationDecorator.new(Merchant.new)
      assert_equal :gross_annual_turnover, registration_gross_annual.current_step
    end

    should "return :registration_small when the registration has a small turnover" do
      registration_small = RegistrationDecorator.new(create(:registration_gross_annual, gross_annual_turnover_cents: 1))
      assert_equal :registration_small, registration_small.current_step
    end

    should "return registration_large when the registration has a large turnover" do
      registration_large = RegistrationDecorator.new(create(:registration_gross_annual, gross_annual_turnover_cents: Merchant::LARGE_TURNOVER_THRESHOLD.cents + 1))
      assert_equal :registration_large, registration_large.current_step
    end
  end

  context "#step_complete?" do
    should "return true when step is complete" do
      registration_small = RegistrationDecorator.new(build(:registration_small))
      assert registration_small.send(:step_complete?, :registration_small)
    end

    should "return false when step is incomplete" do
      registration_gross_annual = RegistrationDecorator.new(build(:registration_gross_annual))
      registration_gross_annual.attrs_to_validate = nil
      refute registration_gross_annual.send(:step_complete?, :registration_small)
    end
  end

  context "#step_attrs_are_valid?" do
    should "return false when any fields for the step are invalid" do
      registration_gross_annual = RegistrationDecorator.new(build(:registration_gross_annual))
      registration_gross_annual.attrs_to_validate = nil
      registration_gross_annual.valid?
      refute registration_gross_annual.send(:step_attrs_are_valid?, :registration_small), "Expected some registration_small attributes to be invalid: #{registration_gross_annual.errors.full_messages}"
    end

    should "return true when no fields for the step are invalid" do
      registration_large = RegistrationDecorator.new(build(:registration_large))
      registration_large.valid?
      assert registration_large.send(:step_attrs_are_valid?, :registration_large), "Expected all registration_large attributes to be valid: #{registration_large.errors.full_messages}"
    end
  end

  context "#set_attributes_to_validate_for_step!" do
    should "set the attributes to validate for a valid step" do
      offer = RegistrationDecorator.new(Merchant.new)
      offer.attrs_to_validate = nil
      offer.set_attributes_to_validate_for_step!('gross_annual_turnover')
      assert_equal RegistrationDecorator::STEP_ATTRS['gross_annual_turnover'], offer.attrs_to_validate
    end

    should "set the attributes to validate to nil for an invalid step" do
      offer = RegistrationDecorator.new(build(:registration_gross_annual))
      refute offer.attrs_to_validate.nil?
      offer.set_attributes_to_validate_for_step!("woooooooooo")
      assert_nil offer.attrs_to_validate
    end
  end

end