require_relative 'browser_test'

class RegistrationTest < BrowserTest

  test "create a new registration w/ small gross annual turnover" do
    visit_new_registration_page

    submit_invalid_gross_annual_turnover
    assert_gross_annual_turnover_errors

    submit_valid_small_gross_annual_turnover
    assert_small_registration_page

    submit_invalid_small_registration
    assert_small_registration_page_errors

    submit_valid_small_registration
    assert_request_info_confirmation
  end

  test "create a new registration w/ large gross annual turnover" do
    visit_new_registration_page
    submit_invalid_gross_annual_turnover

    assert_gross_annual_turnover_errors

    submit_valid_large_gross_annual_turnover
    assert_large_registration_page

    submit_invalid_large_registration
    assert_large_registration_page

    submit_valid_large_registration
    assert_request_info_confirmation
  end

  test "create a new registration w/ small gross annual turnover and test optional validations" do
    visit_new_registration_page

    submit_valid_small_gross_annual_turnover
    assert_small_registration_page

    # some invalid data
    choose 'yes_registered_with_companies_house'
    fill_in 'Password', with: '123456' 
    fill_in 'Confirm password', with: '123456' 

    # accept terms and submit form
    accept_small_registration_terms
    click_on 'Submit Details'
    screenshot!("registration_small_confirmation")
    # assert validation messages
    assert page.has_content? 'Registered Company Number has to be exactly 8 characters long'
    assert page.has_content? 'is too short (minimum is 8 characters)'

    # fix and submit with valid info
    fill_in 'Registered company number', with: '12345678'
    fill_in 'Registered company name', with: 'test co'
    submit_valid_small_registration
    assert_request_info_confirmation
  end

  private

  def visit_new_registration_page
    visit '/registrations/new'
    screenshot!("registration_new")
  end

  def submit_invalid_gross_annual_turnover
    fill_in 'What is your projected Gross Annual Turnover for the financial year?', with: 'not a number'
    click_on 'Next'
  end

  def assert_gross_annual_turnover_errors
    assert page.has_content?('Must be greater than 0')
  end

  def submit_valid_small_gross_annual_turnover
    fill_in 'What is your projected Gross Annual Turnover for the financial year?', with: (Merchant::LARGE_TURNOVER_THRESHOLD.cents - 1).to_f / 100
    click_on 'Next'
  end

  def submit_valid_large_gross_annual_turnover
    fill_in 'What is your projected Gross Annual Turnover for the financial year?', with: Merchant::LARGE_TURNOVER_THRESHOLD.cents.to_f / 100
    click_on 'Next'
  end

  def assert_small_registration_page
    assert page.has_field?('Password')
    assert page.has_field?('Registered company name')
    assert page.has_field?('Main business category')
  end

  def assert_large_registration_page
    assert !page.has_field?('Password')
    assert page.has_field?('Trading name')
    assert page.has_field?('Business e-mail address')
  end

  def accept_small_registration_terms
    find(:css, "#signatory_terms_checkbox").set(true)
    find(:css, "#accept_privacy_and_terms_checkbox").set(true)
  end

  def submit_invalid_small_registration
    accept_small_registration_terms
    fill_in 'Business e-mail address', with: 'invalid email'
    fill_in 'Registered company name', with: 'hello?'
    fill_in 'Business phone number', with: '123456'
    fill_in 'Business mobile number', with: '123456'
    fill_in 'First name', with: ' John_Smith'
    fill_in 'Surname', with: ' John_Smith '
    click_on 'Submit Details'
    screenshot!("registration_small_invalid")
  end

  def assert_small_registration_page_errors
    assert page.has_content?('Please select a valid title'), '1'
    assert page.has_content?('Please enter the first name using only the letters "a" to "z", spaces, and hyphens "-"'), '2'
    assert page.has_content?('Please enter the surname using only the letters "a" to "z", spaces, and hyphens "-"'), '2'
    assert page.has_content?('Please enter more than a single character'), '4'
    assert page.has_content?('The Contact work phone number must be 10 or 11 digits, including the area code'), '6'
    assert page.has_content?('The mobile number must be 11 digits long'), '7'
    assert page.has_content?('is invalid'), '8'
    assert page.has_content?('Please enter more than a single character'), '10'

    # password missing check
    assert has_css? 'fieldset.password.field_with_errors span.help-inline'
    within('fieldset.password.field_with_errors span.help-inline') do
      assert has_content? "can't be blank"
    end
  end

  def submit_invalid_large_registration
    fill_in 'Business e-mail address', with: 'invalid email'
    fill_in 'Trading name', with: 'hello?'
    fill_in 'Business phone number', with: '123456'
    fill_in 'First name', with: ' John_Smith'
    fill_in 'Surname', with: ' John_Smith '
    click_on 'Submit Details'
    screenshot!("registration_small_invalid")
  end

  def submit_valid_small_registration
    accept_small_registration_terms
    valid_attrs = attributes_for(:registration_small)
    fill_in 'Business e-mail address', with: valid_attrs[:contact_work_email_address]
    fill_in 'Position in company', with: valid_attrs[:contact_position]
    fill_in 'Business phone number', with: valid_attrs[:contact_work_phone_number]
    fill_in 'Business mobile number', with: valid_attrs[:contact_work_mobile_number]
    select "Mr", :from => 'Title'
    select "Kids", :from => 'Main business category'
    fill_in 'First name', with: valid_attrs[:contact_first_name]
    fill_in 'Surname', with: valid_attrs[:contact_last_name]
    fill_in 'Password', with: 'passwordtest'
    fill_in 'Confirm password', with: 'passwordtest'
    click_on 'Submit Details'
    screenshot!("registration_small_confirmation")
  end

  def submit_valid_large_registration
    valid_attrs = attributes_for(:registration_large)
    valid_attrs = attributes_for(:registration_small)
    fill_in 'Business e-mail address', with: valid_attrs[:contact_work_email_address]
    fill_in 'Position in company', with: valid_attrs[:contact_position]
    fill_in 'Trading name', with: valid_attrs[:registered_company_name]
    fill_in 'Business phone number', with: valid_attrs[:contact_work_phone_number]
    select "Mr", :from => 'Title'
    fill_in 'First name', with: valid_attrs[:contact_first_name]
    fill_in 'Surname', with: valid_attrs[:contact_last_name]
    click_on 'Submit Details'
    screenshot!("registration_large_confirmation")
  end

  def assert_request_info_confirmation
    assert page.has_content?('Confirmation'), 'Expected confirmation page'
    assert page.has_content?("Thank you for your enquiry. We'll be in touch soon."), "Expected 'thank you' message"
  end
end
