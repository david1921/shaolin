require_relative '../../test_helper'

class Admin::OfferKeyInformationAgreementsControllerTest < ActionController::TestCase

  context "GET to show" do

    setup do
      @ofs = create :offer_setup_form, html: "the offer setup form"
    end

    should "redirect to the sign in url as an anonymous user" do
      get :show, offer_id: @ofs.owner.to_param, id: @ofs.to_param
      assert_redirected_to sign_in_url
    end

    should "render the Offer Setup Page for an admin user" do
      sign_in_as create(:admin_user)
      get :show, offer_id: @ofs.owner.to_param, id: @ofs.to_param
      assert_response :ok
      assert_match /the offer setup form/, @response.body
    end

  end

end
