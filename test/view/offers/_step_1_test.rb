require_relative '../../test_helper'

module Offers
  class Step2PartialTest < ActionView::TestCase
    include SimpleForm::ActionViewExtensions::FormHelper

    setup do
      ActionController::Base.prepend_view_path 'app/views/offers'
    end

    should "render small step 1 fields for a small merchants" do
      @offer = build(:offer_step_1)
      current_user = create(:merchant_user_small)
        
      simple_form_for @offer do |f|
        render partial: 'step_1', locals: { f: f, current_user: current_user }
      end
      
      assert_common_step_1_fields
    end

     should "render large step 1 fields for a small merchants" do
      @offer = build(:offer_step_1)
      current_user = create(:merchant_user_large)
        
      simple_form_for @offer do |f|
        render partial: 'step_1', locals: { f: f, current_user: current_user }
      end
      
      assert_common_step_1_fields
      assert_select "button[data-value='encourage_repeat_business']"
    end


    private

    def assert_common_step_1_fields
      assert_select "input[name='offer[duration]']"
      assert_select "input[name='offer[earliest_start_date]']"
      assert_select "input[name='offer[latest_marketable_date]']"
      assert_select "input[name='offer[objective]']"
      assert_select "select[name='offer[primary_category]']"
      assert_select "select[name='offer[secondary_category]']"
      assert_select "input[name='offer[type]']"
    end
  end
end

