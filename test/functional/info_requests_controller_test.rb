require_relative '../test_helper'

class InfoRequestsControllerTest < ActionController::TestCase

  test "GET /info_requests/new" do
    get :new
    assert_template :new
    assert_not_nil assigns(:info_request)
    assert_select_info_request_form
  end

  test "POST /info_requests with valid attributes" do
    post :create, info_request: attributes_for(:info_request)
    assert_redirected_to confirmation_info_request_path(InfoRequest.last)
  end

  test "POST /info_requests with invalid attributes" do
    post :create, info_request: { email: "invalid email", telephone: "" }
    assert_response :ok
    assert_template :new
    assert_not_nil assigns(:info_request)
  end
  
  test "EMAIL /info_request_confirmation" do
    info_request = FactoryGirl.build(:info_request)
    email = Notifications.info_request_confirmation(info_request).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    assert_equal [info_request.email], email.to
    assert_equal "Info request confirmation", email.subject
    assert_match(/Hello #{info_request.business_name}/, email.encoded )
  end
  
  test "EMAIL /info_request_sales_team" do
    info_request = FactoryGirl.build(:info_request)
    email = Notifications.info_request_sales_team(info_request).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    assert_equal [Notifications::SALES_TEAM], email.to
    assert_equal "Info request sales team", email.subject
    assert_match(/Please contact #{info_request.business_name}/, email.encoded )
    assert_match(/Contact Person: #{info_request.title} #{info_request.first_name} #{info_request.last_name}/, email.encoded )
    assert_match(/Business Name: #{info_request.business_name}/, email.encoded )
    assert_match(/Telephone: #{info_request.telephone}/, email.encoded )
  end
  

  private

  def assert_select_info_request_form
    assert_select "form.new_info_request" do
      assert_select "select[name='info_request[title]']" do
        assert_select "option:first-child[value=]"
        assert_select "option", :minimum => 2
      end
      
      assert_select "input[name='info_request[first_name]']"
      assert_select "input[name='info_request[last_name]']"
      assert_select "input[name='info_request[email]']"
      assert_select "input[name='info_request[business_name]']"

      assert_select "input[name='info_request[telephone]']"
      assert_select "textarea[name='info_request[additional_details]']"
    end
  end
end
