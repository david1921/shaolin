require_relative '../../test_helper'

module Offers
  class Step4PartialTest < ActionView::TestCase
    include SimpleForm::ActionViewExtensions::FormHelper

    setup do
      ActionController::Base.prepend_view_path 'app/views/offers'
    end

    should "render offer review sections for a offer w/ targeting" do
      @offer = create(:offer_step_3, type: 'prepaid')
       simple_form_for @offer do |f|
         render partial: 'step_4', locals: { f: f }
       end
      assert_template partial: 'shared/offer/_key_information_form'
      assert_select "input[type='checkbox'][name='offer[key_information_agreements_attributes][0][electronically_signed]']"
      assert_select "input[type='hidden'][name='offer[key_information_agreements_attributes][0][html]']"
      assert_select "a[href=?]", edit_offer_path(@offer, view_step: 1)
    end
  end
end
