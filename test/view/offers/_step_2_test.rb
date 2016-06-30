require_relative '../../test_helper'

module Offers
  class Step2PartialTest < ActionView::TestCase
    include SimpleForm::ActionViewExtensions::FormHelper

    setup do
      ActionController::Base.prepend_view_path 'app/views/offers'
    end

    should "render prepaid step 2 fields for a prepaid offer" do
      @offer = create(:offer_step_1, type: 'prepaid')

      simple_form_for @offer do |f|
        render partial: 'step_2', locals: { f: f }
      end

      assert_common_step_2_fields
      assert_non_free_step_2_fields
    end

    should "render free step 2 fields for free offers" do
      @offer = create(:offer_step_1, type: 'free')

      simple_form_for @offer do |f|
        render partial: 'step_2', locals: { f: f }
      end

      assert_common_step_2_fields
      assert_non_free_steps_2_fields_not_shown
    end

    should "render free step 2 fields for free offers with targeting" do
      @offer = create(:offer_step_1, type: 'free_with_enhanced_targeting')

      simple_form_for @offer do |f|
        render partial: 'step_2', locals: { f: f }
      end

      assert_common_step_2_fields
      assert_non_free_steps_2_fields_not_shown
    end

    context "merchant customer service details" do
      should "allow details to be provided when required by the merchant" do
        @offer = create(:offer_step_2, type: 'free')
        merchant = @offer.merchant
        merchant.stubs(:needs_customer_service_contact_details?).returns true

        simple_form_for @offer do |f|
          render partial: 'step_2', locals: { f: f }
        end

        assert_select "input[name='offer[merchant_attributes][customer_service_email_address]']"
        assert_select "input[name='offer[merchant_attributes][customer_service_phone_number]']"
      end

      should "not allow details to be provided when not required" do
        @offer = create(:offer_step_2, type: 'free')
        merchant = @offer.merchant
        merchant.stubs(:needs_customer_service_contact_details?).returns false

        simple_form_for @offer do |f|
          render partial: 'step_2', locals: { f: f }
        end

        assert_select "input[name='offer[merchant_attributes][customer_service_email_address]']",
          false, "Customer service phone number should not be required"
        assert_select "input[name='offer[merchant_attributes][customer_service_phone_number]']",
          false, "Customer service email address should not be required"
      end
    end

    private

    def assert_common_step_2_fields
      assert_select "textarea[name='offer[title]']"
      assert_select "input[name='offer[maximum_vouchers]']"
      assert_select "input[name='offer[use_own_vouchers]']"
      assert_select "textarea[name='offer[description]']"
      assert_select "input[name='offer[voucher_expiry]']"
      assert_select "input[name='offer[website_url]']"
      assert_select "input[name='offer[phone]']"
      assert_select "input[name='offer[library_image_id]']"
      assert_select "input[name='offer[choose_own_offer_image]']"

      assert_select "input[name='offer[full_redemption]']"
      assert_select "input[name='offer[new_customers]']"
      assert_select "input[name='offer[no_shows_cancellations_forfeit_voucher]']"
      assert_select "input[name='offer[one_per_transaction_per_visit]']"
      assert_select "input[name='offer[non_transferrable]']"
    end

    def assert_non_free_step_2_fields
      assert_select "input[name='offer[bespoke_price]']"
      assert_select "input[name='offer[original_price]']"
    end

    def assert_non_free_steps_2_fields_not_shown
      assert_select "input[name='offer[bespoke_price]']", false, 'Free Offers cannot have Bespoke Price'
      assert_select "input[name='offer[original_price]']", false, 'Free Offers cannot have Original Price'
    end
  end
end
