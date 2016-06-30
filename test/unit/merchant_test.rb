require_relative '../test_helper'

class MerchantTest < ActiveSupport::TestCase

  context "callbacks" do
    setup do
      @merchant = build(:merchant)
    end

    should "before_create :assign_uuid" do
      @merchant.save!
      assert !@merchant.new_record?, 'Expected a persisted record'
      assert_not_nil @merchant.uuid, "should assign a uuid to the merchant"
    end

    should "before_create :set_accepted_privacy_policy_at" do
      @merchant.save!
      assert !@merchant.new_record?, 'Expected a persisted record'
      assert_not_nil @merchant.privacy_policy_accepted_at, "should assign privacy policy accepted at timestamp to merchant"
    end


    should "before_validation :format_contact_work_phone_numbers" do
      @merchant.contact_work_phone_number = "(071) 2345 6789"
      @merchant.contact_work_mobile_number = "07 123-45 32-11"
      @merchant.valid?
      assert_equal "07123456789", @merchant.contact_work_phone_number
      assert_equal "07123453211", @merchant.contact_work_mobile_number
    end

    should 'append http scheme to business_website_url if none provided, before validation' do
      @merchant.business_website_url = 'www.google.com'
      @merchant.valid?
      assert_equal 'http://www.google.com', @merchant.business_website_url
    end

    should 'NOT change business_website_url if a schema was provided, before validation' do
      @merchant.business_website_url = 'https://www.google.com'
      @merchant.valid?
      assert_equal 'https://www.google.com', @merchant.business_website_url
    end

    should 'NOT change business_website_url if a an invalid uri was provided, before validation' do
      @merchant.business_website_url = 'te`st'
      @merchant.valid?
      assert_equal 'te`st', @merchant.business_website_url
    end

  end


  context "PRIMARY_CATEGORY_KEYS" do
    should "have translations for all primary business categories in the default locale" do
      keys = I18n.t('options.business_categories').keys.map(&:to_s)
      Merchant::PRIMARY_CATEGORY_KEYS.each do |c|
        assert_includes keys, c, "Should have a translations for #{c}"
      end
    end
  end

  context "SECONDARY_CATEGORY_KEYS" do
    should "have translations for all secondary business categories in the default locale" do
      categories = I18n.t('options.secondary_business_categories').with_indifferent_access
      Merchant::SECONDARY_CATEGORY_KEYS.each do |primary_key, value|
        if value.is_a? Array
          value.each do |secondary_key|
            assert_includes categories[primary_key], secondary_key, "Should have a translation for #{secondary_key}"
          end
        else
          assert_equal categories[primary_key], value, "Should have a translation for #{value}"
        end
      end
    end
  end

  context "#gross_annual_turnover" do
    should "be money" do
      merchant = create(:merchant)
      assert merchant.gross_annual_turnover.is_a? Money
    end
  end

  context "#large? and #small?" do
    should "return true if there is a 'large' turnover" do
      merchant = create(:merchant, gross_annual_turnover: Merchant::LARGE_TURNOVER_THRESHOLD + Money.new(1))
      assert merchant.large?
      refute merchant.small?
    end

    should "return false if there is a 'small' turnover" do
      merchant = create(:merchant, gross_annual_turnover: Money.new(1))
      refute merchant.large?
      assert merchant.small?
    end

    should "return true if the turnover is equal to the threshold" do
      merchant = create(:merchant, gross_annual_turnover: Merchant::LARGE_TURNOVER_THRESHOLD)
      assert merchant.large?
      refute merchant.small?
    end
  end

  context "associated user" do
    setup do
      @merchant = build(:merchant)
    end

    should 'start with no associated user' do
      assert_nil @merchant.user
    end

    context "adding a user" do
      setup do
        @user = create(:merchant_user)
        @merchant.user = @user
        @merchant.save!
      end

      should 'have the associated user' do
        @merchant.reload
        assert_equal @user, @merchant.user
      end
    end
  end

  context "merchant_owners" do
    setup do
      @merchant = create :merchant
    end

    should "not have any _owners" do
      assert_equal 0, @merchant.merchant_owners.size, "shouldn't have any"
    end

    should "have 2 merchant_owners" do
      @merchant.merchant_owners << MerchantOwner.new
      @merchant.merchant_owners << MerchantOwner.new
      assert_equal 2, @merchant.merchant_owners.size, 'should have 2'
    end
  end

  context "addresses" do
    setup do
      @merchant = Merchant.new
    end

    should "have registered company address" do
      assert @merchant.respond_to? :registered_company_address
    end

    should "have business address" do
      assert @merchant.respond_to? :business_address
    end

    should "have bank address" do
      assert @merchant.respond_to? :business_bank_address
    end

    [:billing_address,:business_address,:trading_address,:registered_company_address,:business_bank_address].each do |addr|
      context addr do
        should "set #{addr}_id attribute to nil when setting #{addr}_attributes[:_destroy] to 1" do
          @merchant = create(:merchant, "#{addr}" => build(:address))
          @merchant = Merchant.find(@merchant.id)
          @merchant.send("#{addr}_attributes=", {id: @merchant.send(addr).id, _destroy: 1})
          @merchant.save!(validate:false)
          @merchant = Merchant.find(@merchant.id)
          assert_nil @merchant.send(addr), "#{addr} is not nil"
          assert_nil @merchant.send("#{addr}_id"), "#{addr}_id is NOT nil"
        end

        should "set #{addr}_id attribute to nil when destroying #{addr}" do
          @merchant = create(:merchant, "#{addr}" => build(:address))
          @merchant = Merchant.find(@merchant.id)
          @merchant.send(addr).destroy
          @merchant.save!(validate:false)
          @merchant = Merchant.find(@merchant.id)
          assert_nil @merchant.send(addr), "#{addr} is not nil"
          assert_nil @merchant.send("#{addr}_id"), "#{addr}_id is NOT nil"
        end
      end
    end
  end

  context "stores" do
    should "have many stores" do
      assert Merchant.new.respond_to? :stores
    end
  end

  context '#status=' do
    should 'update status when the transition is valid' do
      @merchant = create :registration_small, status: nil
      @merchant.stubs(:valid_transition?).returns(true)
      @merchant.update_attributes! status: 'beef pork town'
      assert_equal 'beef pork town', @merchant.reload.status
    end

    should 'not update the status when the transition is invalid' do
      @merchant = create :registration_small, status: 'draft'
      assert @merchant.valid?
      @merchant.status = 'approved'
      assert !@merchant.save
      assert_match(/Invalid status change/, @merchant.errors[:status].first)
    end
  end

  context '#valid_transition?' do
    should 'transition to draft or pending signature'  do
      @merchant = create :registration_small, status: nil
      assert @merchant.valid_transition?(nil, 'draft')
      assert @merchant.valid_transition?(nil, 'pending signature')
      assert !@merchant.valid_transition?(nil, 'approved')
    end

    should 'transition to pending signature'  do
      @merchant = create :registration_small, status: 'draft'
      assert !@merchant.valid_transition?('draft', 'draft')
      assert @merchant.valid_transition?('draft', 'pending signature')
      assert !@merchant.valid_transition?('draft', 'approved')
    end
  end

  context '#draft?' do
    should 'know if the merchant is draft?' do
      @merchant = create :registration_small, status: 'draft'
      assert @merchant.draft?
      @merchant.status = nil 
      assert @merchant.draft?
    end
    should 'look at the db state for status' do
      @merchant = create :registration_small, status: 'draft'
      @merchant.status = 'submitted'
      assert @merchant.draft?
    end
  end

  context 'when registered with companies house' do
    setup do # ensure the names are all different
      @merchant = build :merchant, registered_company_name: 'RCN', trading_name: 'TN', business_name: 'BN'
    end
    context 'is true, display name' do
      setup do
        @merchant.registered_with_companies_house = true
      end
      should 'be registered company name' do
        assert_equal @merchant.registered_company_name, @merchant.display_name
      end
    end
    context 'is false' do
      setup do
        @merchant.registered_with_companies_house = false
      end
      should 'be business name' do
        assert_equal @merchant.business_name, @merchant.display_name
      end
    end
  end

  context 'merchant validation process' do
    setup do
      @merchant = build :registration_small
    end

    context 'approval' do
      # NOTE: this is placeholder until all the validation logic around approvals is in place
      should 'set merchant status to approved' do
        @merchant.approve_validation
        assert_equal 'approved', @merchant.status
      end
      #context 'barclays customer' do
        #should 'set merchant status to approved' do
          #@merchant.approve_validation
          #assert_equal 'approved', @merchant.status
        #end

        #should 'not require an owner' do
        #end
      #end

      #context 'registered with companies house' do
        #should 'set merchant status to approved' do
          #@merchant.approve_validation
          #assert_equal 'approved', @merchant.status
        #end
        #should 'not require an owner' do
        #end
      #end

      #context 'a GPA merchant' do
        #should 'set merchant status to approved' do
          #@merchant.approve_validation
          #assert_equal 'approved', @merchant.status
        #end
        #should 'not require an owner' do
        #end
      #end

      #context 'not a barclays customer' do
        #context 'not registered with companies house or GPA merchant' do
          #should 'require at least one owner' do
          #end

          #should 'not change status' do
          #end
        #end
      #end
    end

    context 'decline' do
      should 'set merchant status to decline' do
        @merchant.decline_validation
        assert_equal 'declined', @merchant.status
      end
    end

    context 'suspend' do
      should 'set merchant status to suspended' do
        @merchant.suspend
        assert_equal 'suspended', @merchant.status
      end
    end
  end

  context 'validate merchants' do
    should 'first sort for submitted status by barclaycard_gpa_merchant DESC, updated_at ASC
            second sort for approved, declined, suspended statuses by barclaycard_gpa_merchant DESC, updated_at ASC,status' do

      ordered_ids = []
      m1 = create :registration_small, barclaycard_gpa_merchant: true
      m1.update_attribute(:status,'submitted' )
      m1.update_attribute(:updated_at, 5.days.ago )
      ordered_ids << m1.id

      m2 = create :registration_small, barclaycard_gpa_merchant: true
      m2.update_attribute(:status,'submitted' )
      ordered_ids << m2.id

      m3 = create :registration_small
      m3.update_attribute(:status,'submitted' )
      m3.update_attribute(:updated_at, 3.days.ago )
      ordered_ids << m3.id

      m4 = create :registration_small
      m4.update_attribute(:status,'submitted' )
      ordered_ids << m4.id

      m5 = create :registration_small, barclaycard_gpa_merchant: true
      m5.update_attribute(:status,'approved' )
      m5.update_attribute(:updated_at, 6.days.ago )
      ordered_ids << m5.id

      m6 = create :registration_small, barclaycard_gpa_merchant: true
      m6.update_attribute(:status,'declined' )
      m6.update_attribute(:updated_at, 5.days.ago )
      ordered_ids << m6.id

      m7 = create :registration_small
      m7.update_attribute(:status,'approved' )
      m7.update_attribute(:updated_at, 7.days.ago )
      ordered_ids << m7.id

      m8 = create :registration_small
      m8.update_attribute(:status,'declined' )
      m8.update_attribute(:updated_at, 3.days.ago )
      ordered_ids << m8.id

      merchants = Merchant.for_validation

      returned_ids = []
      merchants.each {|m| returned_ids << m.id}
      assert ordered_ids == returned_ids, "should be equal"

    end

  end

  context '#needs_customer_service_contact_details' do
    setup do
      @merchant = build :registration_small
    end

    should 'return true when phone and email address are not set' do
      @merchant.customer_service_phone_number = nil
      @merchant.customer_service_email_address = nil
      assert @merchant.needs_customer_service_contact_details?
    end

    should 'return true when phone or email address are not set' do
      @merchant.customer_service_phone_number = '01234567890'
      @merchant.customer_service_email_address = nil
      assert @merchant.needs_customer_service_contact_details?

      @merchant.customer_service_phone_number = nil
      @merchant.customer_service_email_address = 'foo@example.com'
      assert @merchant.needs_customer_service_contact_details?
    end

    should 'returns false when phone and email address is set' do
      @merchant.customer_service_phone_number = '01234567890'
      @merchant.customer_service_email_address = 'foo@example.com'
      assert !@merchant.needs_customer_service_contact_details?
    end
  end
end
