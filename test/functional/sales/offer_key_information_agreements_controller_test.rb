require_relative "../../test_helper"

class Sales::OfferKeyInformationAgreementsControllerTest < ActionController::TestCase
  
  context "with authorized sales account" do
    
    setup do
      @user  = create(:sales_user)
      @offer = create(:offer)      
      sign_in_as @user      
    end
    
    context "GET :new" do
      
      should "render the new page" do
        get :new, offer_id: @offer
        assert_response :success
        assert_template :new        
      end
      
    end
    
    context "POST :create" do
      setup do
        @controller.stubs(:set_offer)
        @controller.instance_variable_set(:@offer, @offer)
      end

      should "create the new key information agreement and mark the signature as uploaded" do
        mock_kif_params = mock('kif params')
        @controller.stubs(:kif_params).returns(mock_kif_params)
        @controller.expects(:create_kif_for_offer).with(@offer, mock_kif_params).once.returns(true)
        @offer.expects(:signature_uploaded!).once

        post :create, offer_id: @offer, key_information_agreement: attributes_for(:key_information_agreement)
        assert_redirected_to sales_merchants_url
      end
      
      should "raise an exception when KIF creation fails" do
        @controller.stubs(:create_kif_for_offer).raises
        assert_raises RuntimeError do
          post :create, offer_id: @offer, key_information_agreement: {}
        end
      end
      
    end
    
    
  end
  
  context "without authorized account" do
    
    setup do
      @offer = create(:offer)
    end
    
    context "GET :new" do

      should "redirect to new session" do
        get :new, offer_id: @offer
        assert_redirected_to sign_in_path
      end
      
    end

    context "POST :create" do
      
      should "redirect to new session" do
        post :create, offer_id: @offer, key_information_agreement: FactoryGirl.attributes_for(:offer_setup_form)
        assert_redirected_to sign_in_path
      end
      
    end
    
  end
  
end