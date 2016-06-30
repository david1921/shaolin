require_relative '../../../../test_helper'

module Admin
  module Merchants
    module Offers 
      class EditTest < ActionView::TestCase
        setup do
          ActionController::Base.prepend_view_path 'app/views/admin/merchants/offers/'
        end

        context 'render edit' do
          should 'render edit with correct form date formats' do
            Timecop.freeze(2012, 1, 1) do
              @offer = create :offer
              @merchant = @offer.merchant
              render template: :edit
              expected_value = @offer.earliest_start_date.strftime("%-d/%-m/%Y")
              assert_select "input#offer_earliest_start_date[value='#{expected_value}']"
            end
          end
        end
      end
    end
  end
end
