module BrowserTests
  module AdminOffersHelper
    def ensure_some_merchant_offers(n=2)
      count = @merchant.offers.count
      count >= n or (n - count).times { create(:offer, merchant: @merchant) }
    end

    def assert_new_offer_link
      assert page.has_css?('a', text: 'New Offer', message: 'Expected new offer link')
    end

    def assert_list_of_offers_with_edit_links
      # the class is in the template is indeed 'merchant_row', for whatever reason (cut/paste error?)
      assert page.has_css?('.merchant_row a', text: 'Edit', minimum: 2), 'Expected a list of offers'
    end

    def save_progress_new_offer_using_test_data
      click_on 'Load Test Data'
      click_button 'Save Progress'
    end

    def assert_on_namespaced_merchant_offers_page(namespace, merchant)
      assert_equal "/#{namespace.to_s}/merchants/#{merchant.to_param}/offers", current_path
    end

    def assert_on_namespaced_offers_page_kia_page(namespace, offer)
      assert_equal "/#{namespace.to_s}/offers/#{offer.to_param}/key_information_agreements/new", current_path
    end
  end
end
