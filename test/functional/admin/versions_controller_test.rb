require_relative '../../test_helper'

class Admin::VersionsControllerTest < ActionController::TestCase

  test '#index' do
    @merchant = create(:merchant)
    get :index, :merchant_id => @merchant.to_param
    assert_template :index
  end


end

