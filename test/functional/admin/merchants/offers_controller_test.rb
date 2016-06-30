require_relative "../../../test_helper"

class Admin::Merchants::OffersControllerTest < ActionController::TestCase

  def setup
    @admin_user = create :admin_user
    @merchant = create :merchant
  end

  context "GET to new" do

    should "be routeable via the admin merchant namespace" do
      assert_generates "/admin/merchants/1/offers/new", controller: "admin/merchants/offers", merchant_id: 1, action: :new
    end

    should "redirect a sales user to '/'" do
      sign_in_as(create(:sales_user))
      get :new, merchant_id: @merchant.to_param
      assert_redirected_to '/'
    end

    should "redirect an anonymous user to the sign in page" do
      get :new, merchant_id: @merchant.to_param
      assert_redirected_to sign_in_url
    end

    context "as an admin user" do

      setup do
        sign_in_as @admin_user
      end

      should "be accessible by an admin user" do
        get :new, merchant_id: @merchant.to_param
        assert_response :success
        assert_template 'admin/merchants/offers/edit'
      end

      should "raise an ActiveRecord::RecordNotFound if no merchant is found for the given merchant_id" do
        assert_raises(ActiveRecord::RecordNotFound) { get :new, merchant_id: "XXX" }
      end

      should "set @merchant to the merchant and @offer to a new offer" do
        get :new, merchant_id: @merchant.to_param
        assert_instance_of Merchant, assigns(:merchant)
        assert_instance_of Offer, assigns(:offer)
      end

      should "render the new offer form" do
        get :new, merchant_id: @merchant.to_param
        assert_response :success
        assert_select "form#new_offer"
      end

    end

  end

  context "POST to create" do

    setup do
      sign_in_as @admin_user
    end

    context "with validation errors" do

      should "rerender the edit template and not create a new offer" do
        assert_no_difference "Offer.count" do
          post :create, merchant_id: @merchant.to_param, offer: attributes_for(:offer).except(:title)
        end
        assert_response :ok
        assert_template "edit"
        assert_instance_of Offer, assigns(:offer)
        assert assigns(:offer).errors.present?, "invalid offer should have errors set"
      end

    end

    context "with valid data entered" do

      should "create a new offer assigned to the current merchant" do
        assert_difference "Offer.count" do
          post :create, merchant_id: @merchant.to_param, offer: attributes_for(:offer)
        end
        assert_redirected_to new_admin_offer_key_information_agreement_url(assigns(:offer))
      end

    end

  end

  context "GET to edit" do

    setup do
      sign_in_as @admin_user
      offer_setup_form = create(:offer_setup_form)
      @offer = offer_setup_form.owner
    end

    should "successfully render the edit template, and include a link to the Offer Setup Form" do
      get :edit, merchant_id: @offer.merchant_id, id: @offer.to_param
      assert_response :ok
      assert_equal @offer, assigns(:offer)
      assert_equal @offer.merchant, assigns(:merchant)
      assert_template "edit"
      assert_select "a[href=#{admin_offer_key_information_agreement_path(@offer.to_param, @offer.key_information_agreements.last.to_param)}]", text: "View Offer Setup Form"
    end

    should "show the price values correctly" do
      @offer.original_price = 5
      @offer.bespoke_price = 2.5
      @offer.save
      get :edit, merchant_id: @offer.merchant_id, id: @offer.to_param
      assert_response :ok
      assert_select "input#offer_original_price[value=5.00]"
      assert_select "input#offer_bespoke_price[value=2.50]"
    end

  end

  context "POST to create with params[:commit] == 'Save Progress'" do

    should "save the record without validation and redirect to the edit page" do
      sign_in_as(@admin_user)
      assert_difference "Offer.count" do
        post :create, merchant_id: @merchant.to_param, offer: { title: "a partially complete offer" }, commit: "Save Progress"
      end
      offer = assigns(:offer)
      assert_instance_of Offer, offer
      assert_redirected_to admin_merchant_offers_url(@merchant)
      assert !offer.new_record?, "saved in-progress offer should not be a new record"
      assert_equal "a partially complete offer", offer.title
    end

  end

  context "POST to create and redemption outlet options" do

    setup do
      sign_in_as(@admin_user)
      @store_1 = create :store, merchant: @merchant
      @store_2 = create :store, merchant: @merchant
    end

    should "associate stores with the offer when params[:offer][:store_ids] is present" do
      assert_difference "Offer.count" do
        post :create, merchant_id: @merchant.to_param, offer: attributes_for(:offer).merge(store_ids: [@store_1.id])
      end
      offer = assigns(:offer)
      assert_equal [@store_1], offer.stores
      assert_redirected_to new_admin_offer_key_information_agreement_url(offer)
    end

 end

 context "PUT to update with redemption outlet options" do

   setup do
     sign_in_as(@admin_user)
     @store_1 = create :store, merchant: @merchant
     @store_2 = create :store, merchant: @merchant
   end

   should "replace existing stores with newly selected stores, when they change" do
     offer = create :offer, merchant: @merchant
     offer.stores << @store_1
     put :update, merchant_id: @merchant.to_param, id: offer.to_param, offer: { store_ids: [@store_2.id] }
     assert_redirected_to new_admin_offer_key_information_agreement_url(offer)
     offer.reload
     assert_equal [@store_2], offer.stores
   end

   should "clear the stores if no stores are provided w/ valid offer params" do
     offer = create :offer, merchant: @merchant
     offer.stores << @store_1
     put :update, merchant_id: @merchant.to_param, id: offer.to_param, offer: { title: "a new title that is long enough" }
     assert_redirected_to new_admin_offer_key_information_agreement_url(offer)
     offer.reload
     assert offer.stores.blank?, "offer stores should be blank"
   end

    should "not clear the stores if no stores are provided w/ invvalid offer params" do
     offer = create :offer, merchant: @merchant
     offer.stores << @store_1
     put :update, merchant_id: @merchant.to_param, id: offer.to_param, offer: { title: "" }
     assert_response :ok
     assert_template :edit
     offer.reload
     refute offer.stores.blank?, "offer stores should not be blank"
   end

 end

 context "PUT to update, simulating unchecked targeting options" do

   should "not cause a validation error" do
     sign_in_as(@admin_user)
     offer = create :offer
     put :update, merchant_id: offer.merchant.to_param, id: offer.to_param, offer: { target_spend_per_transaction_with_merchant: [""] }
     assert_redirected_to new_admin_offer_key_information_agreement_url(offer)
     offer = assigns(:offer)
     assert_instance_of Offer, offer
     assert offer.errors.blank?, "offer with blank target_spend_per_transaction_with_merchant should not have errors"
   end

 end

  context "PUT to update, concurrently editing the same offer"  do
    should "flash error message with second update of the same offer" do
      sign_in_as(create(:admin_user))

      offer = create :offer, merchant: @merchant
      assert_equal offer.lock_version, 0, "should have lock version of 0"

      put :update,
          merchant_id: offer.merchant.to_param,
          id: offer.to_param,
          offer: { description: "This offer has been edited" }
      assert_redirected_to send("new_admin_offer_key_information_agreement_url", offer), "should be redirected to KIA"
      assert_equal Offer.find(offer.id).lock_version, 1, "should have lock version of 1"

      #Simulate race condition
      Offer.class_eval do
        attr_accessible :lock_version
      end

      put :update,
          merchant_id: offer.merchant.to_param,
          id: offer.to_param,
          offer: { description: "This offer was edited", lock_version: 0 }
      assert_template :edit
      assert_equal "Offer was modified by another user while you were editing", flash[:error]
    end
  end

end
