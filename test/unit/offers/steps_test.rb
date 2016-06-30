require_relative '../../test_helper'

class Offers::StepsTest < ActiveSupport::TestCase

  context "ATTRS_TO_VALIDATE_FROM_DRAFT_STEP" do
    should "require step for all steps" do
      Offer::ATTRS_TO_VALIDATE_FROM_DRAFT_STEP.values do |attributes|
        assert_include attributes, :step
      end
    end

    should "contain all required attributes for step 1" do
      step_1_attributes = [
        :user,
        :merchant,
        :status,
        :step,
        :duration,
        :earliest_start_date,
        :latest_marketable_date,
        :objective,
        :primary_category,
        :secondary_category,
        :type
      ]
      assert_same_elements step_1_attributes, Offer::ATTRS_TO_VALIDATE_FROM_DRAFT_STEP[1]
    end

    should "contain all required attributes for step 2" do
      step_2_attributes = [
        :user,
        :merchant,
        :status,
        :step,
        :duration,
        :earliest_start_date,
        :latest_marketable_date,
        :objective,
        :primary_category,
        :secondary_category,
        :type,
        :bespoke_price,
        :description,
        :full_redemption,
        :library_image,
        :maximum_vouchers,
        :new_customers,
        :no_shows_cancellations_forfeit_voucher,
        :non_transferrable,
        :one_per_transaction_per_visit,
        :original_price,
        :title,
        :voucher_expiry,
#       :earliest_redemption,
        :redemption_website_url,
        :redemption_phone_number,
        :stores,
        :use_own_vouchers, 
        :choose_own_offer_image,
        :phone
      ]
      assert_same_elements step_2_attributes, Offer::ATTRS_TO_VALIDATE_FROM_DRAFT_STEP[2]
    end
    
    should "contain all validated attributes except known exclusions in the final step" do
      validated_attrs = Offer.validators.map(&:attributes).flatten.uniq
      final_step_attrs = Offer::ATTRS_TO_VALIDATE_FROM_DRAFT_STEP[Offer::DRAFT_STEPS.max]
      exclusions = [
        :earliest_redemption,
        :negotiated_pre_paid_offer_commission_rate,
        :pricing_attestation,
        :claims_attestation,
        :permissions_attestation,
        :capacity_attestation
      ]
      missing_attrs = validated_attrs - final_step_attrs - exclusions
      message = "Offer attributes [#{missing_attrs.join(', ')}] are validated by Offer but are not included in "   +
        "ATTRS_TO_VALIDATE_FROM_DRAFT_STEP. Please add each one to the hash or the exclusions list in this test. " +
        "Add to the exclusions list only if there's a valid reason for the attribute not to be validated during"   +
        "the self-serve setup process."
      assert missing_attrs.empty?, message
    end
  end

  context "#update_step_and_attributes" do
    should "raise an exception if the step is not a valid next step for the offer" do
      offer = create(:offer_step_1)
      error = assert_raise(RuntimeError) { offer.update_step_and_attributes(3, {}, reset_later_attributes: true) }
      assert_match /invalid transition/i, error.message
    end

    should "return false and not increment the step if invalid attributes are passed" do
      offer = create(:offer_step_2)
      assert !offer.update_step_and_attributes(1, { objective: nil }, { reset_later_attributes: true })
      assert_equal 2, offer.reload.step
    end

    should "update, increment the step, reset any invalid attributes for later steps when passed valid data" do
      offer = create(:offer_step_1, duration: 10)
      offer.update_step_and_attributes(2, attributes_for(:offer_step_2, duration: 20), { reset_later_attributes: true })
      offer.reload
      assert_equal 2, offer.step
      assert_equal 20, offer.duration
    end

    should "reset invalid attributes for later steps when called with the reset_later_attributes option" do
      offer = create(:offer_step_1, description: "x")
      assert_equal true, offer.update_step_and_attributes(1, {}, { reset_later_attributes: true })
      offer.reload
      assert_equal 1, offer.step
      assert_nil offer.description
    end

    should "save values that will be invalid in later steps when called without the reset_later_attributes option" do
      offer = create(:offer_step_1)
      offer.expects(:invalid_attributes_for_later_steps).never
      assert_equal true, offer.update_step_and_attributes(1, { description: "x" })
      offer.reload
      assert_equal 1, offer.step
      assert_equal "x", offer.description
    end
  end

  context "#attrs_to_validate" do
    should "return the attributes for the current step" do
      offer = Offer.new
      offer.step = 1
      assert_equal Offer::ATTRS_TO_VALIDATE_FROM_DRAFT_STEP[1], offer.attrs_to_validate
      offer.step = 2
      assert_equal Offer::ATTRS_TO_VALIDATE_FROM_DRAFT_STEP[2], offer.attrs_to_validate
    end
  end

  context "#attrs_to_validate=" do
    should "raise an exception when called" do
      offer = Offer.new
      assert_raise(RuntimeError) { offer.attrs_to_validate = [] } 
    end
  end

  context "checked_next_step" do
    should "return the step if it is within range and less than the current step" do
      offer = build(:offer_step_2)
      assert_equal 1, offer.send(:checked_next_step, "1")
    end

    should "return the step if it is within range and equal to the current step" do
      offer = build(:offer_step_2)
      assert_equal 2, offer.send(:checked_next_step, "2")
    end

    should "return the step if it is within range and equal to the current step plus one" do
      offer = build(:offer_step_2)
      assert_equal 3, offer.send(:checked_next_step, "3")
    end

    should "return nil if the step is before the first legal step" do
      offer = build(:offer_step_2)
      assert_nil offer.send(:checked_next_step, "5"), "Should return nil for an illegal step"
    end
  end
end
