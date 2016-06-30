require_relative '../test_helper'
require File.expand_path 'app/extensions/address_binder'

class AddressBinderTest < Test::Unit::TestCase

  context 'when params has one empty address and one non empty address, and mark empty addresses for deletion,' do
    setup do
      params = { foo: 1, bar: 2, first_address_attributes: { line1: nil, line2: nil, id: '1' }, second_address_attributes: { line1: 'test', line2: nil, id: '2' } }
      @fake = get_target params
      @fake.mark_empty_addresses_for_deletion
    end
    should 'mark empty address for deletion' do
      assert_marked_for_destroy @fake.params[:first_address_attributes], true
    end
    should 'NOT mark non empty address for deletion' do
      assert_marked_for_destroy @fake.params[:second_address_attributes], false
    end
  end

  context 'when model hash has one empty address and one non empty address, and mark empty addresses for deletion based on custom regex,' do
    setup do
      @model_hash = { foo: 1, bar: 2, first_address: { line1: nil, line2: nil, id: '1' }, second_address_attributes: { line1: 'test', line2: nil, id: '1' } }
      fake = get_target @model_hash
      fake.mark_empty_addresses_for_deletion @model_hash, /_address$/
    end
    should 'mark matching empty address for deletion' do
      assert_marked_for_destroy @model_hash[:first_address], true
    end
    should 'NOT mark conventional address for deletion' do
      assert_marked_for_destroy @model_hash[:second_address_attributes], false
    end
  end

  context 'when model hash as a blank address with no id, and mark empty addresses for deletion' do
    setup do
      @model_hash = { address_attributes: { line1: nil, line2: nil, id: nil } }
      fake = get_target @model_hash
      fake.mark_empty_addresses_for_deletion @model_hash
    end
    should 'NOT mark for deletion' do
      assert_marked_for_destroy @model_hash[:address_attributes], false
    end
  end

  def assert_marked_for_destroy(address, value)
    assert(address.key?(:_destroy) == value, "Expected address to#{' NOT' if !value} be marked for destroy, but it was#{' not' if value}.")
  end

  def get_target(params)
    stub(params: params).extend(AddressBinder)
  end

end