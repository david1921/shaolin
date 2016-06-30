require_relative '../../../test/test_helper'

class RegistrationsHelperTest < ActionView::TestCase

  context "#registration_url_for_form" do
    should "return the create path for new records" do
      assert_equal registrations_path, registration_path_for_form(Merchant.new)
    end

    should "return the update path for existing records" do
      merchant = create(:merchant)
      assert_equal registration_path(merchant.uuid), registration_path_for_form(merchant)
    end
  end
  
end
