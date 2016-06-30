require_relative '../test_helper'

class StoreTest < ActiveSupport::TestCase
  test 'can create with address attributes' do
    merchant = create :merchant
    attrs = { 
      name: 'Test Store', 
      address_attributes: FactoryGirl.attributes_for(:address), 
      email_address: 'test@example.com', 
      opening_hours: 'all nite', 
      phone_number: '07987654321' }
    store = Store.new attrs
    merchant.stores << store
    assert !store.new_record?
  end

  should_validate_attribute_with_validator(Store, :merchant, ActiveModel::Validations::PresenceValidator)
  should_validate_attribute_with_validator(Store, :address, ActiveModel::Validations::PresenceValidator)

  should "have many offers" do
    assert Store.new.respond_to?(:offers)
  end

  should "accept nested attributes for address" do
    Store.expects(:accepts_nested_attributes_for).with(:address)
    quietly { load "#{Rails.root}/app/models/store.rb" }
  end

  should "have a valid phone number" do
    verify_attribute_validated_with_validator(Store, :phone_number, LandlinePhoneValidator)
  end
end
