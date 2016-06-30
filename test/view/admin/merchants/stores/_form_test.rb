require_relative '../../../../test_helper'

module Admin
  module Merchants
    module Stores
      class FormPartialTest < ActionView::TestCase

        setup do
          ActionController::Base.prepend_view_path 'app/views/admin/merchants/stores/'
          @merchant = create(:merchant)
          @store = Store.new
          @store.build_address
        end

        should 'render fields for all accessible store attributes' do
          render 'form'

          assert_select "input[name='store[address_attributes][address_line_1]']"
          assert_select "input[name='store[address_attributes][address_line_2]']"
          assert_select "input[name='store[address_attributes][address_line_3]']"
          assert_select "input[name='store[address_attributes][address_line_4]']"
          assert_select "input[name='store[address_attributes][address_line_5]']"
          assert_select "input[name='store[address_attributes][post_town]']"
          assert_select "input[name='store[address_attributes][postcode]']"
          assert_select "input[type='submit']"
        end

      end
    end
  end
end

