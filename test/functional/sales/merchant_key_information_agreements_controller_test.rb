require_relative "../../test_helper"

class Sales::MerchantKeyInformationAgreementsControllerTest < ActionController::TestCase

  context "GET to :new, with a secondary_business_category value of ''" do
    
    should "render the page successfully" do
      merchant = create :merchant, secondary_business_category: ""
      sign_in_as(create(:sales_user))
      get :new, merchant_id: merchant.to_param
      assert_response :ok
    end

  end

end
