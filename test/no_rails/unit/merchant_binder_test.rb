require_relative '../test_helper'
require File.expand_path 'app/extensions/address_binder'
require File.expand_path 'app/extensions/merchant_binder'

class MerchantBinderTest < Test::Unit::TestCase
  [:billing_address_is_registered_company_address, 
   :billing_address_is_trading_address, 
   :billing_address_is_business_address].each do |field|
    context "when #{field.to_s} is checked" do
      setup do
        @target = get_target do |merchant|
          merchant[field] = '1'
          merchant[:billing_address_attributes] = address_attibutes
        end
      end
      should 'mark billing address for destruction' do
        assert @target.merchant_params[:billing_address_attributes].key? :_destroy
      end
    end
  end
  context "when trading_address_is_registered_company_address is checked" do
    setup do
      @target = get_target do |merchant| 
        merchant[:trading_address_is_registered_company_address] = '1'
        merchant[:trading_address_attributes] = address_attibutes
      end
    end
    should 'mark tading address for destruction' do
      assert @target.merchant_params[:trading_address_attributes].key? :_destroy
    end
  end
  context "when trading_name_is_registered_company_name is checked" do
    setup do
      @target = get_target do |merchant| 
        merchant[:trading_name_is_registered_company_name] = '1'
        merchant[:trading_name] = 'test'
      end
    end
    should 'set trading name to nil' do
      assert_nil @target.merchant_params[:trading_name]
    end
  end
  context "when registered_with_companies_house" do
    context 'is checked' do
      setup do
        @target = get_target do |merchant|
          merchant[:registered_with_companies_house] = '1'
          merchant[:business_address_attributes] = address_attibutes
          merchant[:business_name] = 'test'
        end
      end
      should 'mark business address for destruction' do
        assert @target.merchant_params[:business_address_attributes].key? :_destroy
      end
      should 'set business name to nil' do
        assert_nil @target.merchant_params[:business_name]
      end
    end
    context 'is un-checked' do
      setup do
        @target = get_target do |merchant|
          merchant[:registered_with_companies_house] = '0'
          merchant[:registered_company_address_attributes] = address_attibutes
          merchant[:registered_company_name] = 'test'
        end
      end
      should 'mark registered company address for destruction' do
        assert @target.merchant_params[:registered_company_address_attributes].key? :_destroy
      end
      should 'set registered company name to nil' do
        assert_nil @target.merchant_params[:registered_company_name]
      end
    end
  end
  context 'when submitting' do
    setup do
      @target = get_target
      @target.params[:submit] = 'anything'
    end
    should 'set status to draft' do
      assert_equal 'pending signature', @target.merchant_params[:status]
    end
  end
  context 'when saving' do
    setup do
      @target = get_target
      @target.params[:save] = 'anything'
    end
    should 'set status to draft' do
      assert_equal 'draft', @target.merchant_params[:status]
    end
  end
  def get_target
    merchant = { }
    yield merchant if block_given?
    stub(params: { merchant: merchant }).extend ::MerchantBinder
  end
  def address_attibutes
    { address_line_1: '100 High St', address_line_2: nil, address_line_3: nil, address_line_4: nil, address_line_5: nil, post_town: 'London', postcode: 'AA99 9AA', id: '1' }
  end
end