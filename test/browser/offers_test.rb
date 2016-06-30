require_relative 'browser_test'
require 'ruby-debug'

class OffersTest < BrowserTest

  def teardown
    clean_database
  end

  test "offers small" do
    require_javascript_driver!
    user = create(:merchant_user_small)
    sign_in user.email, attributes_for(:user)[:password]

    screenshot!('small_offer_step_1')
    visit_new_offers_page
    assert_step_1_small_offers_fields
    submit_invalid_step_1_small_offer
    assert_step_1_small_offer_errors
    submit_valid_step_1_small_offer
    screenshot!('small_offer_step_2')
    assert_step_2_small_offers_fields
    assert_pricing_details_not_shown_for_non_pre_paid_offer

    fill_in_partial_step_2_small_offers_fields
    save_progress
    assert_progress_saved_marked
    change_step_2_small_offers_form
    assert_save_progress_marked
    visit(current_path)
    assert_step_2_small_offers_saved_progress
    submit_valid_step_2_small_offer
    screenshot!('small_offer_step_3')
    
    assert_step_3_small_offer_fields
    submit_valid_step_3_small_offer
    screenshot!('small_offer_step_4')

    assert_step_4_small_offer_fields
    submit_invalid_step_4_small_offer
    assert_step_4_small_offer_errors
    submit_valid_step_4_small_offer
    screenshot!('small_offer_step_5')

    assert_step_5_small_offer_fields
  end

  test "free offer" do
    require_javascript_driver!

    user = create(:merchant_user_small)
    sign_in user.email, attributes_for(:user)[:password]

    offer = create(:offer_step_1, type: 'free', merchant: user.merchant)
    visit_edit_offer_page(offer)

    screenshot!('free_offer_step_2')
    assert_step_2_small_offers_fields
    submit_valid_step_2_small_offer

    screenshot!('free_offer_step_4')
    assert_step_4_small_offer_fields
  end

  test "offers large" do
    require_javascript_driver!
    user = create(:merchant_user_large)
    sign_in user.username, attributes_for(:user)[:password]

    visit_new_offers_page
    screenshot!('large_offer_step_1')
    assert_step_1_large_offers_fields
    submit_invalid_step_1_large_offer
    assert_step_1_large_offer_errors
    submit_valid_step_1_large_offer
    screenshot!('large_offer_step_2')
    assert_step_2_large_offers_fields

    fill_in_partial_step_2_large_offers_fields
    save_progress
    assert_progress_saved_marked
    change_step_2_large_offers_form
    assert_save_progress_marked
    visit(current_path)
    assert_step_2_large_offers_saved_progress
    submit_valid_step_2_large_offer
    screenshot!('large_offer_step_3')

    assert_step_3_large_offer_fields
    submit_valid_step_3_large_offer
    screenshot!('large_offer_step_4')

    assert_step_4_large_offer_fields
    submit_invalid_step_4_large_offer
    assert_step_4_large_offer_errors
    submit_valid_step_4_large_offer
    screenshot!('large_offer_step_5')

    assert_step_5_large_offer_fields
  end

  private

  def visit_new_offers_page
    visit '/offers/new'
    screenshot!("offers_new")
  end

  def visit_edit_offer_page(offer)
    visit "/offers/#{offer.to_param}/edit"
  end

  def save_progress
    click_on 'Save your progress'
  end

  def assert_progress_saved_marked
    assert page.has_css?("button.save_progress.saved"), "Should have marked button as saved"
  end

  def assert_save_progress_marked
    assert page.has_css?("button.save_progress:not(.saved)"), "Should have marked button as saved"
  end

  # Small Merchant Specific Methods

  def assert_step_1_small_offers_fields
    assert page.has_content?("Select a type of offer")
    assert page.has_css?("button[data-value='drive_sales']")
    assert page.has_css?("button[data-value='get_new_customers']")
    assert page.has_field?("Primary category")
    assert page.has_field?("Secondary category")
    assert page.has_field?("Earliest start date")
    assert page.has_field?("Duration")
    assert page.has_field?("Latest marketable date")
    assert page.has_button?("Next")
  end

  def submit_invalid_step_1_small_offer
    click_on 'Next'
  end

  def assert_step_1_small_offer_errors
    assert page.has_css?("section.category fieldset.field_with_errors")
    assert page.has_css?("section.select_date fieldset.field_with_errors")
  end

  def submit_valid_step_1_small_offer
    valid_attributes = attributes_for(:offer_step_1)
    choose 'offer_type_free_with_enhanced_targeting'
    click_on 'Get new customers'
    select 'Electricals', from: 'offer_primary_category'
    select 'Appliances', from: 'offer_secondary_category'
    fill_in 'offer_earliest_start_date', with: valid_attributes[:earliest_start_date].strftime("%d/%m/%Y")
    fill_in 'offer_duration', with: valid_attributes[:duration]
    fill_in 'offer_latest_marketable_date', with: valid_attributes[:latest_marketable_date].strftime("%d/%m/%Y")
    click_on 'Next'
  end

  def assert_step_2_small_offers_fields
    assert page.has_css?("textarea[name='offer[title]']")
  end

  def fill_in_partial_step_2_small_offers_fields
    fill_in 'offer_title', with: "This"
    find(:css, "#offer_full_redemption").set(true)
    create(:library_image)
    click_link 'Choose offer image'
    find('.image_gallery_over').trigger(:mouseover)
    wait_until { page.find('.image_gallery_over').visible? }
    click_on "Click to view"
    click_on 'Yes'
  end

  def assert_step_2_small_offers_saved_progress
    assert page.has_field?("offer_title", with: "This"), "Should have saved title"
    assert find(:css, "#offer_full_redemption").checked?, "Should have full redemption checked"
  end

  def change_step_2_small_offers_form
    fill_in 'offer_title', with: "This is different"
  end

  def submit_valid_step_2_small_offer
    valid_attributes = attributes_for(:offer_step_2, type: 'prepaid')
    fill_in 'offer_title', with: valid_attributes[:title]
    fill_in 'offer_maximum_vouchers', with: valid_attributes[:maximum_vouchers]
    fill_in 'offer_description', with: valid_attributes[:description]
    fill_in 'offer_voucher_expiry', with: valid_attributes[:voucher_expiry]
    find(:css, "#offer_full_redemption").set(true)
    create(:library_image)
    click_link 'Choose offer image'
    find('.image_gallery_over').trigger(:mouseover)
    wait_until { page.find('.image_gallery_over').visible? }
    click_on "Click to view"
    click_on 'Yes'
    click_button 'Next'
  end

  def submit_valid_step_3_small_offer
    uncheck 'offer_target_all'
    check '18-34'
    check 'Female'
    check '0-40000'
    click_on 'Next'
  end

  def assert_step_3_small_offer_errors
    assert page.has_content?("must be accepted"), 4, 'have the error for all unchecked step 3 options'
  end

  def assert_step_3_small_offer_fields
    assert page.has_content? 'Select your target audience'
    assert page.has_css?("input[name='offer[target_all]']"), 'should have a target all option'
  end

  def assert_step_4_small_offer_fields
    assert page.has_content? 'Your offer summary'
  end
  
  def submit_invalid_step_4_small_offer
    find(:css, "#offer_key_information_agreements_attributes_0_electronically_signed").set(false)
    click_on 'Next'
  end

  def assert_step_4_small_offer_errors
    assert page.has_css?("fieldset.field_with_errors")
  end
  
  def  submit_valid_step_4_small_offer
    find(:css, "#offer_key_information_agreements_attributes_0_electronically_signed").set(true)
    click_on 'Next'
  end

  def assert_step_5_small_offer_fields
    assert page.has_content? 'Thank you for submitting your offer.'
  end
  # Large Merchant Specific Methods

  def assert_step_1_large_offers_fields
    assert page.has_content?("Select a type of offer")
    assert page.has_css?("button[data-value='drive_sales']")
    assert page.has_css?("button[data-value='get_new_customers']")
    assert page.has_css?("button[data-value='encourage_repeat_business']")
    assert page.has_field?("Primary category")
    assert page.has_field?("Secondary category")
    assert page.has_field?("Earliest start date")
    assert page.has_field?("Duration")
    assert page.has_field?("Latest marketable date")
    assert page.has_button?("Next")
  end


  def submit_invalid_step_1_large_offer
    submit_invalid_step_1_small_offer
  end

  def assert_step_1_large_offer_errors
    assert_step_1_small_offer_errors
  end

  def submit_valid_step_1_large_offer
    submit_valid_step_1_small_offer
  end

  def assert_step_2_large_offers_fields
    assert_step_2_small_offers_fields
  end

  def fill_in_partial_step_2_large_offers_fields
    fill_in_partial_step_2_small_offers_fields
  end

  def assert_step_2_large_offers_saved_progress
    assert_step_2_small_offers_saved_progress
  end

  def change_step_2_large_offers_form
    change_step_2_small_offers_form
  end

  def submit_valid_step_2_large_offer
    submit_valid_step_2_small_offer
  end

  def assert_step_3_large_offer_fields
    assert_step_3_small_offer_fields
  end

  def assert_pricing_details_not_shown_for_non_pre_paid_offer
    refute page.has_content?("Pricing details"), 'Prepaid offer should not show pricing details'
  end

  def submit_valid_step_3_large_offer
    submit_valid_step_3_small_offer
  end

  def assert_step_4_large_offer_fields
    assert_step_4_small_offer_fields
  end

  def submit_invalid_step_4_large_offer
    submit_invalid_step_4_small_offer
  end

  def assert_step_4_large_offer_errors
    assert_step_4_small_offer_errors
  end

  def submit_valid_step_4_large_offer
    submit_valid_step_4_small_offer
  end
 
  def assert_step_5_large_offer_fields
    assert_step_5_small_offer_fields
  end
end
