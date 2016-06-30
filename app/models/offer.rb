require 'offers/has_offer_targeting_criteria'

class Offer < ActiveRecord::Base
  include ::Options::Categories
  include Offers::Steps
  include Offers::Validation
  include Offers::HasOfferTargetingCriteria

  self.inheritance_column = 'unused_sti_column'

  STATUSES = ['draft', 'pending signature', 'cancelled', 'submitted', 'rejected', 'approved']
  DRAFT_STEPS = ATTRS_TO_VALIDATE_FROM_DRAFT_STEP.keys.sort
  TYPES = ['prepaid', 'free', 'free_with_enhanced_targeting']
  SMALL_OBJECTIVES = ['drive_sales', 'get_new_customers', 'encourage_repeat_business']
  LARGE_OBJECTIVES = ['drive_sales', 'get_new_customers']

  has_many :offer_targeting_criteria, class_name: "OfferTargetingCriterion"
  has_offer_targeting_criteria :target_age_ranges,
                               allowed_values: OfferTargetingCriterion::TARGET_AGE_RANGES,
                               criterion_type: OfferTargetingCriterion::TYPES::AGE
  has_offer_targeting_criteria :target_genders,
                               allowed_values: OfferTargetingCriterion::TARGET_GENDERS,
                               criterion_type: OfferTargetingCriterion::TYPES::GENDER
  has_offer_targeting_criteria :target_annual_incomes,
                               allowed_values: OfferTargetingCriterion::TARGET_ANNUAL_INCOMES,
                               criterion_type: OfferTargetingCriterion::TYPES::ANNUAL_INCOME
  has_offer_targeting_criteria :target_distance_from_location,
                               allowed_values: OfferTargetingCriterion::TARGET_DISTANCES_FROM_LOCATION,
                               criterion_type: OfferTargetingCriterion::TYPES::DISTANCE_FROM_LOCATION
  has_offer_targeting_criteria :target_spend_per_transaction_with_merchant,
                               allowed_values: OfferTargetingCriterion::TARGET_SPEND_PER_TRANSACTION_WITH_MERCHANT,
                               criterion_type: OfferTargetingCriterion::TYPES::SPEND_PER_TRANSACTION_WITH_MERCHANT
  has_offer_targeting_criteria :target_spend_per_transaction_in_sector,
                               allowed_values: OfferTargetingCriterion::TARGET_SPEND_PER_TRANSACTION_IN_SECTOR,
                               criterion_type: OfferTargetingCriterion::TYPES::SPEND_PER_TRANSACTION_IN_SECTOR
  has_offer_targeting_criteria :target_spend_frequency_per_week_with_merchant,
                               allowed_values: OfferTargetingCriterion::TARGET_SPEND_FREQUENCY_PER_WEEK_WITH_MERCHANT,
                               criterion_type: OfferTargetingCriterion::TYPES::SPEND_FREQUENCY_PER_WEEK_WITH_MERCHANT
  has_offer_targeting_criteria :target_spend_frequency_per_week_in_sector,
                               allowed_values: OfferTargetingCriterion::TARGET_SPEND_FREQUENCY_PER_WEEK_IN_SECTOR,
                               criterion_type: OfferTargetingCriterion::TYPES::SPEND_FREQUENCY_PER_WEEK_IN_SECTOR


  attr_accessor :redeemable_at_outlets
  #
  # Monetized attributes validate numericality by default
  #
  monetize :original_price_cents, allow_nil: true
  monetize :bespoke_price_cents, allow_nil: true

  attr_accessible :description,
                  :additional_restrictions,
                  :duration,
                  :earliest_start_date,
                  :earliest_redemption,
                  :full_redemption,
                  :latest_marketable_date,
                  :library_image_id,
                  :maximum_vouchers,
                  :new_customers,
                  :non_transferrable,
                  :no_shows_cancellations_forfeit_voucher,
                  :objective,
                  :one_per_transaction_per_visit,
                  :original_price,
                  :bespoke_price,
                  :phone,
                  :primary_category,
                  :secondary_category,
                  :title,
                  :type,
                  :voucher_expiry,
                  :website_url,
                  :use_merchant_supplied_voucher_code,
                  :use_merchant_supplied_image,
                  :target_age_ranges,
                  :target_genders,
                  :target_annual_incomes,
                  :target_distance_from_location,
                  :target_spend_per_transaction_with_merchant,
                  :target_spend_per_transaction_in_sector,
                  :target_spend_frequency_per_week_with_merchant,
                  :target_spend_frequency_per_week_in_sector,
                  :can_redeem_online,
                  :redemption_website_url,
                  :can_redeem_by_phone,
                  :redemption_phone_number,
                  :can_redeem_at_outlets,
                  :outlet_redemption,
                  :store_ids,
                  :allow_social_media_sharing,
                  :pricing_attestation,
                  :capacity_attestation,
                  :claims_attestation,
                  :permissions_attestation,
                  :standard_pre_paid_offer_commission_rate,
                  :negotiated_pre_paid_offer_commission_rate,
                  :target_all,
                  :use_own_vouchers,
                  :choose_own_offer_image,
                  :key_information_agreements_attributes,
                  :merchant_attributes

  #
  # === Associations
  #
  belongs_to :merchant
  accepts_nested_attributes_for :merchant
  belongs_to :library_image
  belongs_to :user
  has_many :key_information_agreements, as: :owner
  has_and_belongs_to_many :stores

  accepts_nested_attributes_for :key_information_agreements
  #
  # === Validations
  #
  validates :user, presence: true
  validates :merchant, presence: true
  validates :status, inclusion: { in: STATUSES }, allow_blank: false
  validates :step, inclusion: { in: DRAFT_STEPS }, allow_blank: false

  validates :type, inclusion: { in: TYPES }, allow_blank: false
  validates :objective, inclusion: { in: -> record { record.merchant.large? && LARGE_OBJECTIVES || SMALL_OBJECTIVES }}, allow_blank: false,
    if: -> record { record.merchant.present? }
  validates :primary_category, inclusion: { in: PRIMARY_CATEGORY_KEYS }, allow_blank: false
  validates :secondary_category, inclusion: { in: -> record { SECONDARY_CATEGORY_KEYS[record.primary_category] }}, allow_blank: false,
    if: -> record { PRIMARY_CATEGORY_KEYS.include?(record.primary_category) }
  validates :earliest_start_date, presence: true
  validates :earliest_start_date, date: { after_or_equal_to: -> record { Time.zone.now.to_date + 2.weeks }}, allow_blank: true
  validates :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 90 }, allow_nil: true
  
  validates :latest_marketable_date, presence: true
  # offer duration of 1 day correctly allows earliest_start_date and latest_marketable_date to be equal
  validates :latest_marketable_date, date: { after_or_equal_to: -> record { (record.earliest_start_date + record.duration) - 1.day }}, allow_nil: true,
    if: -> record { record.earliest_start_date.present? && record.duration.present? }

  validates :title, presence: true
  validates :title, length: { minimum: 12, maximum: 90 }, allow_blank: true
  validates :original_price, :bespoke_price, presence: true, if: :prepaid?
  validates_each :original_price, :bespoke_price do |record, attr, value|
    record.errors.add attr, :greater_than, count: 0 unless value.blank? || value.positive?
  end
  validates_each :bespoke_price do |record, attr, value|
    record.errors.add attr, :less_than_original_price unless value.blank? || record.original_price.blank? || value < record.original_price
  end
  validates :maximum_vouchers, presence: true
  validates :maximum_vouchers, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
  validates :description, length: { minimum: 20, maximum: 3000 }, allow_blank: false
  validates :voucher_expiry, presence: true
  validates :voucher_expiry, date: { after_or_equal_to: :latest_marketable_date }, allow_nil: true
  validates :earliest_redemption, presence: true
  validates :earliest_redemption, date: { after_or_equal_to: :earliest_start_date }, allow_nil: true
  validates :redemption_website_url, presence: true, :if => :can_redeem_online?
  with_options if: :can_redeem_by_phone? do |this|
    this.validates :redemption_phone_number, presence: true
    this.validates :redemption_phone_number, landline_phone: true, allow_blank: true
  end
  validates :library_image, presence: true, unless: :use_merchant_supplied_image?

  with_options unless: :standard_pre_paid_offer_commission_rate? do |this|
    this.validates :negotiated_pre_paid_offer_commission_rate, presence: true
    this.validates :negotiated_pre_paid_offer_commission_rate, numericality: { greater_than: 0, less_than: 100 }, allow_nil: true
  end
  validates :pricing_attestation, :claims_attestation, :permissions_attestation, :capacity_attestation, acceptance: { accept: true }
  validates :phone, landline_phone: true

  def target_all
    offer_targeting_criteria.empty?
  end

  def target_all=(value)
    offer_targeting_criteria.clear if value
  end

  def free?
    type == 'free'
  end

  def free_with_enhanced_targeting?
    type == 'free_with_enhanced_targeting'
  end

  def prepaid?
    type == 'prepaid'
  end

  def can_redeem_at_selected_outlets?
    can_redeem_at_outlets? && stores.present?
  end

  def stores_can_redeem_at
    self.can_redeem_at_selected_outlets? ? self.stores : self.merchant.stores
  end

  #
  # The status functionality needs to done via state_machine gem
  # once the actual flow is better understood
  #
  def signature_uploaded!
    if key_information_agreements.blank?
      raise "Signature is absent, cannot mark submitted"
    else
      write_attribute(:status, "submitted")
    end
    save!
  end
end

