require_relative '../test_helper'

class OfferTest < ActiveSupport::TestCase
  class << self
    def should_be_required_on_prepaid_offers(price_column_name)
      should "be required on prepaid offers" do
        offer = build :submitted_offer
        offer.type = 'prepaid'
        assert_valid offer
        assert offer.send(price_column_name).present?, "#{price_column_name} should be present on prepaid offer"
        offer.send("#{price_column_name}=", nil)
        assert offer.invalid?, "prepaid offer with #{price_column_name} nil should be invalid"
        assert offer.errors[price_column_name].present?, "offer should have errors on #{price_column_name}"
      end
    end

    def should_not_be_required_on_free_offers(price_column_name)
      should "not be required on free offers" do
        offer = build :free_offer
        assert offer.send(price_column_name).blank?, "offer #{price_column_name} should be blank"
        assert_valid offer
        assert offer.send("#{price_column_name}=", 10)
        assert_valid offer
      end
    end
  end

  context "simple validations" do
    should_validate_attribute_with_validator(Offer, :description, ActiveModel::Validations::LengthValidator,
      { minimum: 20, maximum: 3000, allow_blank: false })

    should_validate_attribute_with_validator(Offer, :duration, ActiveModel::Validations::PresenceValidator)
    should_validate_attribute_with_validator(Offer, :duration, ActiveModel::Validations::NumericalityValidator,
      { only_integer: true, greater_than: 0, less_than_or_equal_to: 90, allow_nil: true } )

    should_validate_attribute_with_validator(Offer, :earliest_start_date, ActiveModel::Validations::PresenceValidator)

    should_validate_attribute_with_validator(Offer, :latest_marketable_date, ActiveModel::Validations::PresenceValidator)

    should_validate_attribute_with_validator(Offer, :merchant, ActiveModel::Validations::PresenceValidator)

    should_validate_attribute_with_validator(Offer, :primary_category, ActiveModel::Validations::InclusionValidator,
      { in: Offer::PRIMARY_CATEGORY_KEYS, allow_blank: false })

    should_validate_attribute_with_validator(Offer, :step, ActiveModel::Validations::InclusionValidator,
      { in: Offer::DRAFT_STEPS, allow_blank: false })

    should_validate_attribute_with_validator(Offer, :title, ActiveModel::Validations::PresenceValidator)
    should_validate_attribute_with_validator(Offer, :title, ActiveModel::Validations::LengthValidator,
      { minimum: 12, maximum: 90, allow_blank: true })

    should_validate_attribute_with_validator(Offer, :type, ActiveModel::Validations::InclusionValidator,
      { in: Offer::TYPES, allow_blank: false })

    should_validate_attribute_with_validator(Offer, :voucher_expiry, ActiveModel::Validations::PresenceValidator)
    should_validate_attribute_with_validator(Offer, :voucher_expiry, ActiveModel::Validations::DateValidator,
      { after_or_equal_to: :latest_marketable_date, allow_nil: true } )

    should_validate_attribute_with_validator(Offer, :original_price, ActiveModel::Validations::PresenceValidator)

    should_validate_attribute_with_validator(Offer, :bespoke_price, ActiveModel::Validations::PresenceValidator)

    should_validate_attribute_with_validator(Offer, :redemption_phone_number, ActiveModel::Validations::PresenceValidator)
    should_validate_attribute_with_validator(Offer, :redemption_phone_number, LandlinePhoneValidator,
      { allow_blank: true })

    should "not validate redemption_phone_number if can_redeem_by_phone is not set" do
      offer = build :submitted_offer, can_redeem_by_phone: false, redemption_phone_number: nil
      assert_valid offer
      offer.redemption_phone_number = "123"
      assert_valid offer
    end

    # context "#earliest_redemption" do
    #   should "be valid only if >= earliest_start_date" do
    #     offer = build :submitted_offer, earliest_redemption: nil
    #     assert offer.invalid?, "offer with nil earliest_redemption should be invalid"
    #     offer.earliest_redemption = offer.earliest_start_date - 1
    #     assert offer.invalid?, "offer with earliest_redemption less than earliest_start_date should be invalid"
    #     offer.earliest_redemption = offer.earliest_start_date
    #     assert_valid offer
    #   end
    # end

    context "#redemption_website_url" do
      should "be required only if can_redeem_online is true" do
        offer = build :submitted_offer
        offer.can_redeem_online = false
        offer.redemption_website_url = nil
        assert_valid offer
        offer.can_redeem_online = true
        assert offer.invalid?, "offer should be invalid when can_redeem_online is true, and redemption_website_url is blank"
        offer.redemption_website_url = "http://test.url"
        assert_valid offer
      end
    end

    context "#latest_marketable_date" do
      should "be valid only if >= earliest_start_date + duration" do
        Timecop.freeze(Time.parse("2012-12-10 11:51:19Z")) do
          start_date = Time.parse("2013-01-10 11:51:19Z")
          offer = build :submitted_offer, earliest_start_date: start_date, duration: 5, latest_marketable_date: nil
          assert_invalid offer, "with nil latest_marketable_date"
          assert offer.errors[:latest_marketable_date].present?, "offer should have errors on :latest_marketable_date"
          offer.voucher_expiry = offer.latest_marketable_date = offer.earliest_start_date + offer.duration
          assert_valid offer
        end
      end

      should "not be checked if earliest_start_date is not set" do
        timestamp = Time.parse("2012-12-10 11:51:19Z")
        Timecop.freeze(timestamp) do
          offer = build :submitted_offer, earliest_start_date: nil, duration: 5, latest_marketable_date: timestamp
          assert_invalid offer, "with nil earliest_start_date"
          refute offer.errors[:latest_marketable_date].present?, "offer should not have errors on :latest_marketable_date"
        end
      end

      should "not be checked if duration is not set" do
        Timecop.freeze(Time.parse("2012-12-10 11:51:19Z")) do
          start_date = Time.parse("2013-01-10 11:51:19Z")
          offer = build :submitted_offer, earliest_start_date: start_date, duration: nil, latest_marketable_date: start_date
          assert_invalid offer, "with nil duration"
          refute offer.errors[:latest_marketable_date].present?, "offer should not have errors on :latest_marketable_date"
        end
      end
    end

    context "#original_price" do
      should_be_required_on_prepaid_offers(:original_price)
      should_not_be_required_on_free_offers(:original_price)
    end

    context "#bespoke_price" do
      should_be_required_on_prepaid_offers(:bespoke_price)
      should_not_be_required_on_free_offers(:bespoke_price)
    end

    context "#earliest_start_date" do
      should "be present" do
        verify_attribute_validated_with_validator(Offer, :earliest_start_date, ActiveModel::Validations::PresenceValidator)
      end

      should "not allow an earliest start date to be before the 2 weeks from the current date if changed" do
        offer = build(:submitted_offer, earliest_start_date: Time.zone.now.to_date)
        assert_invalid offer, "with earliest start date less than 2 weeks from today"
        assert_includes offer.errors[:earliest_start_date], "Please select a day that is at least 2 weeks away from today"

        offer.earliest_start_date = (Time.zone.now + 2.weeks).to_date
        offer.valid?
        assert offer.errors[:earliest_start_date].blank?
      end
    end

    context "#maximum_vouchers" do
      should "be required" do
        offer = build :submitted_offer
        assert_valid offer
        assert offer.maximum_vouchers.present?, "maximum_vouchers should be present"
        offer.maximum_vouchers = nil
        assert offer.invalid?, "offer with nil maximum_vouchers should be invalid"
        offer.maximum_vouchers = 100
        assert_valid offer
      end
    end

    context "#secondary_category" do
      should "only be validated if a valid primary_category has been selected" do
        offer = build(:offer_step_1, primary_category: nil)
        assert_invalid offer, "with primary category not set"
        assert offer.errors[:secondary_category].blank?

        offer.primary_category = "fake category"
        offer.secondary_category = "mobile"
        assert_invalid offer, "when the primary_category is not valid"
        assert_blank offer.errors[:secondary_category]

        offer.primary_category = "electrical"
        offer.secondary_category = "chainsaws"
        assert_invalid offer, "with a secondary category not in Offer::SECONDARY_CATEGORIES_KEYS"
        assert_includes offer.errors[:secondary_category], "Please select a valid secondary category"

        offer.primary_category = "electrical"
        offer.secondary_category = ""
        assert_invalid offer, "with a blank secondary category"
        assert_includes offer.errors[:secondary_category], "Please select a valid secondary category"

        offer.primary_category = "electrical"
        offer.secondary_category = nil
        assert_invalid offer, "with a nil secondary category"
        assert_includes offer.errors[:secondary_category], "Please select a valid secondary category"

        offer.secondary_category = "mobile"
        assert_valid offer
      end
    end

    context "#title" do

      should "allow a maximum of 90 characters" do
        offer = build :submitted_offer
        assert_valid offer
        offer.title = "X" * 91
        assert offer.invalid?, "offer with 91 character title should be invalid"
        assert offer.errors[:title].present?, "offer should have errors on title"
        offer.title = "X" * 90
        assert_valid offer
      end

    end

    context "#objective" do
      should "not validate when there is no merchant present" do
        offer = build(:offer, merchant: nil, objective: nil)
        assert offer.invalid?
        assert offer.errors[:objective].blank?
      end

      should "only allow SMALL_OBJECTIVES for small merchants" do
        offer = build(:offer, merchant: create(:registration_small))
        invalid_options = Offer::LARGE_OBJECTIVES - Offer::SMALL_OBJECTIVES

        invalid_options.each do |option|
          offer.objective = option
          assert offer.invalid?
          assert offer.errors[:objective].find { |e| e =~ /please select a valid/i }
        end

        Offer::SMALL_OBJECTIVES.each do |option|
          offer.objective = option
          assert_valid offer
        end
      end

      should "only allow LARGE_OBJECTIVES for large merchants" do
        offer = build(:submitted_offer, merchant: create(:registration_large))
        invalid_options = Offer::SMALL_OBJECTIVES - Offer::LARGE_OBJECTIVES
        invalid_options.each do |option|
          offer.objective = option
          assert offer.invalid?
          assert offer.errors[:objective].find { |e| e =~ /please select a valid/i }
        end

        Offer::LARGE_OBJECTIVES.each do |option|
          offer.objective = option
          assert_valid offer
        end
      end

      should "not allow objective to be nil" do
        offer = build(:submitted_offer, merchant: create(:registration_large), objective: nil)
        assert_invalid offer, "with nil objective"
        assert_equal 1, offer.errors[:objective].size
        assert_match /please select a valid objective/i, offer.errors[:objective].last
      end
    end

    context 'phone' do
      should 'be validated' do
        offer = build(:submitted_offer)
        offer.phone = '06123456789'
        assert offer.invalid?, "Offer with invalid phone number should be invalid"
        offer.phone = '01123456789'
        assert offer.valid?, "Offer with a valid phone number should be valid"
      end
    end

    context "pricing options" do
      context "#bespoke_price" do
        should "be validated as present if the offer is prepaid" do
          offer = build(:offer_step_2, type: 'prepaid', bespoke_price: nil)
          assert_invalid offer
          assert offer.errors[:bespoke_price].present?
        end

        should "not be validated as present if the offer is not prepaid" do
          offer = build(:offer_step_2, type: 'free', bespoke_price: nil)
          assert_valid offer
          refute offer.errors[:bespoke_price].present?
        end
      end
    end
  end

  context "#duration" do
    should "have a default of 30 days" do
      offer = Offer.new
      assert_equal 30, offer.duration
    end
  end

  context "#target_age_ranges" do

    setup do
      @offer = create :offer, target_age_ranges: nil
    end

    should "store the target age ranges" do
      assert @offer.target_age_ranges.blank?, "@offer.target_age_ranges should be blank"
      @offer.target_age_ranges = %w(18-34 35-55)
      @offer.save!
      assert_equal %w(18-34 35-55), Offer.find(@offer.id).target_age_ranges

      @offer.target_age_ranges = %w(18-34)
      @offer.save!
      assert_equal %w(18-34), Offer.find(@offer.id).target_age_ranges
    end

    should "preserve existing target age ranges if the record is not saved" do
      @offer.target_age_ranges = %w(18-34 35-55)
      @offer.save!
      assert_equal %w(18-34 35-55), Offer.find(@offer.id).target_age_ranges

      @offer.target_age_ranges = %w(18-34)
      assert_equal %w(18-34 35-55), Offer.find(@offer.id).target_age_ranges
    end

    should "be invalid with useful error messages when invalid age ranges are set" do
      @offer.target_age_ranges = %w(xyz)
      assert @offer.invalid?, "@offer with invalid target_age_ranges should be invalid"
      assert_equal ["'xyz' is not a valid target age range"], @offer.errors[:target_age_ranges]
    end

  end

  context "#stores" do
    should "have many stores" do
      assert Offer.new.respond_to?(:stores)
    end
  end

  context "#can_redeem_at_selected_outlets?" do
    should "return false if #can_redeem_at_outlets? is false" do
      offer = build(:offer, can_redeem_at_outlets: false)
      assert !offer.can_redeem_at_outlets?
      assert !offer.can_redeem_at_selected_outlets?
    end

    should "return false if #can_redeem_at_outlets? is true, but no stores are associated to the offer" do
      offer = build(:offer, can_redeem_at_outlets: true)
      assert offer.can_redeem_at_outlets?
      assert !offer.can_redeem_at_selected_outlets?
    end

    should "return true if #can_redeem_at_outlets? is true and stores are associated to this offer" do
      offer = create(:offer, can_redeem_at_outlets: true)
      offer.stores << create(:store, merchant: offer.merchant)
      assert offer.can_redeem_at_outlets?
      assert offer.reload.stores.present?
      assert offer.can_redeem_at_selected_outlets?
    end
  end

  context "attestation flags" do
    should "all be true for the offer to be valid" do
      offer = build :offer
      offer.send(:write_attribute, :status, 'pending signature')
      attestations = [:pricing_attestation, :permissions_attestation, :capacity_attestation, :claims_attestation]
      attestations.each do |flag|
        assert offer.send(flag), "#{flag} should be true by default"
      end
      assert_valid offer

      attestations.each do |flag|
        offer.send("#{flag}=", false)
        assert offer.invalid?, "offer should be invalid when #{flag} is false"
      end
    end
  end

  context "#status" do
    should "set status to default on save progress" do
      offer = Offer.new
      offer.title = "This is a new offer"
      offer.save(validate: false)
      offer.reload
      assert_equal "draft", offer.status
    end

    should "set status to submitted when submitted and signature uploaded" do
      offer = create :offer_step_2
      kif = create(:key_information_agreement, owner: offer)

      offer.reload
      offer.signature_uploaded!
      offer.reload
      assert_equal "submitted", offer.status
    end
  end

  context '#user' do
    setup do
      @offer = create(:offer)
      assert @offer.respond_to? :user
    end

    should "have a user" do
      @offer = build(:offer)
      @offer.user = nil
      assert_invalid @offer
      assert @offer.errors[:user]
    end
  end

  context 'when merchant has stores, and offer can redeem at outlets' do
    setup do
      #TODO: Make an offer factory that creates stores
      @offer = create :offer, can_redeem_at_outlets: true
      @offer.merchant.stores << [ create(:store, merchant: @offer.merchant), create(:store, merchant: @offer.merchant) ]
    end
    context 'and has selected stores, stores can redeem at' do
      setup do
        @offer.stores << @offer.merchant.stores[0]
      end
      should 'be selected stores' do
        assert_equal @offer.stores_can_redeem_at, @offer.stores
      end
    end
    context 'and has no selected stores, stores can redeem at' do
      should 'be all stores for merchant' do
        assert_equal @offer.stores_can_redeem_at, @offer.merchant.stores
      end
    end
  end

  should "have custom error message when bespoke price is not less than original price" do
    offer = build :submitted_offer, original_price: 20.0, bespoke_price: 20.0
    assert_invalid offer, "with bespoke price greater than original price"
    assert_equal 1, offer.errors[:bespoke_price].size, "Should have one error on bespoke_price"
    assert_match /enter a value that is less than the original price/i, offer.errors[:bespoke_price].last
  end

  should "generate exactly one error on required attributes when they are missing" do
    missing_attrs = [
      :objective,
      :primary_category,
      :earliest_start_date,
      :duration,
      :latest_marketable_date,
      :title,
      :original_price,
      :bespoke_price,
      :maximum_vouchers,
      :description,
      :voucher_expiry,
#     :earliest_redemption,
      :redemption_website_url,
      :redemption_phone_number,
      :negotiated_pre_paid_offer_commission_rate
    ]
    fixed_attrs = { type: 'prepaid', can_redeem_online: true, can_redeem_by_phone: true, standard_pre_paid_offer_commission_rate: false }
    offer = build(:submitted_offer, fixed_attrs.merge(Hash[missing_attrs.map { |attr| [attr, nil] }]))
    assert_invalid offer, "with required attributes set to nil"
    missing_attrs.each do |attr|
      assert_equal 1, offer.errors[attr].size, "Should have one error on nil #{attr} but have '#{offer.errors[attr].join(",")}'"
    end

    offer = build(:submitted_offer, fixed_attrs.merge(Hash[missing_attrs.map { |attr| [attr, ""] }]))
    assert_invalid offer, "with required attributes set to blank"
    missing_attrs.each do |attr|
      assert_equal 1, offer.errors[attr].size, "Should have one error on blank #{attr} but have '#{offer.errors[attr].join(",")}'"
    end
  end

  context "validation in draft steps" do
    setup do
      @valid_attrs = {
        user: (user = build(:merchant_user)),
        merchant: user.merchant,
        type: 'prepaid',
        objective: 'drive_sales',
        primary_category: 'entertainment',
        secondary_category: 'cinema',
        earliest_start_date: (start_date = (Time.zone.now. + 2.weeks + 1.day).to_date),
        duration: 30,
        latest_marketable_date: start_date + 30.days,
        title: "This is my totally awesome offer!",
        description: "This is a my offer description",
        original_price: 1,
        bespoke_price: 0.5,
        maximum_vouchers: 1000,
        voucher_expiry: start_date + 30.days,
        earliest_redemption: start_date,
        can_redeem_online: true,
        redemption_website_url: "http://www.example.com",
        can_redeem_by_phone: true,
        redemption_phone_number: "01482987654",
        library_image: build(:library_image)
      }
      @invalid_attrs_from_draft_step = {
        0 => {
          user: nil,
        },
        1 => {
          type: 'foo',
          objective: 'bar',
          primary_category: 'baz',
          earliest_start_date: (start_date = Time.zone.now.to_date),
          duration: 0,
          latest_marketable_date: start_date - 2.days
        },
        2 => {
          title: "x",
          description: "y",
          original_price: -1,
          bespoke_price: -0.5,
          maximum_vouchers: -3,
          voucher_expiry: start_date - 3.days,
#         earliest_redemption: start_date - 1.day,
          redemption_website_url: nil,
          redemption_phone_number: nil
        }
      }
    end

    should "mark an offer valid if it has valid attributes for its step and invalid attributes for later steps" do
      @invalid_attrs_from_draft_step.keys.each do |step|
        invalid_attrs = @invalid_attrs_from_draft_step.select { |key, _| step < key }.values.inject({}) { |memo, attrs| memo.merge!(attrs) }
        offer = build(:offer, @valid_attrs.merge(invalid_attrs))
        offer.send(:write_attribute, :status, 'draft')
        offer.send(:write_attribute, :step, step)
        assert offer.valid?, "Offer should be valid in step #{step} but has errors: #{offer.errors.full_messages}"
      end
    end

    should "mark an offer invalid if it has invalid attributes for its step and valid attributes for later steps" do
      @invalid_attrs_from_draft_step.keys.each do |step|
        invalid_attrs = @invalid_attrs_from_draft_step.select { |key, _| step >= key }.values.inject({}) { |memo, attrs| memo.merge!(attrs) }
        offer = build(:offer, @valid_attrs.merge(invalid_attrs))
        offer.send(:write_attribute, :status, 'draft')
        offer.send(:write_attribute, :step, step)
        assert offer.invalid?, "Should be invalid in step #{step} with invalid attributes for step and valid for others"
        invalid_attrs.keys.each do |attr|
          assert offer.errors[attr].present?, "Should have error on invalid '#{attr}' value '#{offer.send(attr)}' in step #{offer.step}"
        end
      end
    end
  end

  private

  def build_key_information_agreement(attrs = {})
    FactoryGirl.create(:offer).key_information_agreements.new do |instance|
      attrs.each_pair { |key, val| instance.send "#{key}=", val }
      instance.expects(:save_attached_files).at_least(0).returns(true)
    end
  end
end

