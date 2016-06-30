require_relative '../../test_helper'
require 'ostruct'

class LayoutHelperTest < ActionView::TestCase

  context "#render_bespoke_signoff_image" do
    should "renders the image only once" do
      assert_match "images/bespoke_signoff.png", render_bespoke_signoff_image
      assert_nil render_bespoke_signoff_image
    end
  end

  context "#footer_partial_for user" do
    setup do
      @antonio   = OpenStruct.new(:is_merchant? => true)
      @levene    = OpenStruct.new(:is_merchant? => false)
    end

    should "return the merchant footer for merchant users" do
      assert_match "shared/merchant_footer", footer_partial_for(@antonio)
    end

    should "return the non merchant footer for non merchants" do
      assert_match "shared/non_merchant_footer", footer_partial_for(@levene)
    end

    should "return the merchant footer for nil users" do
      assert_match "shared/merchant_footer", footer_partial_for(nil)
    end
  end

end
