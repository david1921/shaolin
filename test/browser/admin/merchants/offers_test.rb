require_relative '../../browser_test'
require_relative '../../../../test/browser/lib/admin_offers_helper'

module Admin
  module Merchants
    class OffersTest < BrowserTest
      include BrowserTests::AdminOffersHelper

      def setup
        @admin_user = create(:admin_user)
        @merchant = create(:merchant)
      end

      def test_index
        ensure_some_merchant_offers
        sign_in @admin_user
        visit "/admin/merchants/#{@merchant.to_param}/offers"
        assert_new_offer_link
        assert_list_of_offers_with_edit_links
      end

      def test_new
        sign_in @admin_user
        visit "/admin/merchants/#{@merchant.to_param}/offers/new"
        save_progress_new_offer_using_test_data
        assert_on_namespaced_merchant_offers_page(:admin, @merchant)
      end

      def test_edit
        @offer = create(:offer, merchant: @merchant)
        sign_in @admin_user
        visit "/admin/merchants/#{@merchant.to_param}/offers/#{@offer.to_param}/edit"
        click_button 'Submit'
        assert_on_namespaced_offers_page_kia_page(:admin, @offer)
      end
      
      def test_edit_select_all_targeting
        offer = create(:offer, merchant: @merchant, offer_targeting_criteria: [create(:offer_targeting_age_criterion)])
        refute offer.target_all
        sign_in @admin_user
        visit "/admin/merchants/#{@merchant.to_param}/offers/#{offer.to_param}/edit"
        check 'offer_target_all'
        click_button 'Submit'

        offer.reload
        assert offer.offer_targeting_criteria.blank?
      end

      def test_edit_with_all_targeting
        offer = create(:offer, merchant: @merchant, offer_targeting_criteria: [])
        assert offer.target_all
        sign_in @admin_user
        visit "/admin/merchants/#{@merchant.to_param}/offers/#{offer.to_param}/edit"
        assert find(:css, "#offer_target_all[checked='checked']"), "Should have target all checked"
        assert page.has_selector?("#targeting_options", visible: false), "Should have no targeting options displayed" 
      end

      def test_edit_with_some_targeting
        criterion = create(:offer_targeting_gender_criterion)
        offer = criterion.offer
        refute offer.target_all
        sign_in @admin_user
        visit "/admin/merchants/#{@merchant.to_param}/offers/#{offer.to_param}/edit"
        refute page.has_css?("#offer_target_all[checked='checked']"), "Should have target all unchecked"
        assert page.has_selector?("#targeting_options", visible: true), "Should have targeting options displayed"
      end
    end
  end
end
