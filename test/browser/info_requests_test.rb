require_relative 'browser_test'

class InfoRequestsTest < BrowserTest

  test "info request" do
    visit_new_info_request_page
    fill_in_valid_info_request_form
    click_on "Submit"
    assert_info_request_confirmation_page
  end

  private

  def visit_new_info_request_page
    visit "/info_requests/new"
    screenshot!("info_request_new")
  end

  def fill_in_valid_info_request_form
    select 'Mr', from: "Title"
    fill_in 'First name', with: 'Jon'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Business name', with: 'My Business'
    fill_in 'E-mail address', with: "valid@address.com"
    fill_in 'Phone number', with: '020 1111 1111'
    fill_in 'Please describe your query', with: 'this is my query description'
  end

  def assert_sales_team_email_was_sent
    email = ActionMailer::Base.deliveries[-1]
    assert_present email, "Sales team email was not sent"
    assert_equal [Notifications::SALES_TEAM], email.to
  end

  def assert_info_request_confirmation_page
    assert page.find("h1")
    assert_sales_team_email_was_sent
    screenshot!("info_request_confirmation")
  end

end
