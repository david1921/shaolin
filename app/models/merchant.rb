require 'valid_email/email_validator'

# Responsible for collecting data during the registration
# process, allowing data to be saved along the way.
#
# At the end of the registration process, the registration object
# should be checked that all necessary fields are filled out.
# This validation should happen outside of Rails validation.
class Merchant < ActiveRecord::Base
  include Encryption::AttrEncrypted
  include SelectiveValidation::Base
  include Bespoke::Contact::Validation
  include ::Options::Categories

  allows_selective_validation

  #
  # === Associations
  #

  belongs_to :user
  has_many :offers
  has_many :merchant_owners
  has_many :key_information_agreements, as: :owner
  belongs_to :registered_company_address, class_name: Address, dependent: :destroy
  belongs_to :trading_address, class_name: Address, dependent: :destroy
  belongs_to :business_address, class_name: Address, dependent: :destroy
  belongs_to :billing_address, class_name: Address, dependent: :destroy
  belongs_to :business_bank_address, class_name: Address, dependent: :destroy
  has_many :stores, dependent: :destroy

  #
  # Vestal Versions
  #
  # see app/models/extensions/audit.rb
  audited :initial_version => true

  attr_encrypted  :contact_title,
                  :contact_first_name,
                  :contact_last_name,
                  :contact_work_phone_number,
                  :contact_work_mobile_number,
                  :contact_work_email_address,
                  :business_bank_account_name,
                  :business_bank_account_number,
                  :business_bank_sort_code,
                  :business_bank_name

  attr_accessible :contact_title,
                  :contact_first_name,
                  :contact_last_name,
                  :contact_position,
                  :contact_work_phone_number,
                  :contact_work_mobile_number,
                  :contact_work_email_address,
                  :legal_representative,

                  :registered_with_companies_house,
                  :registered_company_name,
                  :registered_company_number,
                  :trading_name_is_registered_company_name,
                  :trading_name,
                  :trading_address_is_registered_company_address,
                  :billing_address_is_registered_company_address,
                  :billing_address_is_trading_address,
                  :business_name,
                  :billing_address_is_business_address,

                  :business_website_url,
                  :primary_business_category,
                  :secondary_business_category,
                  :gross_annual_turnover_cents,
                  :barclaycard_gpa_merchant,
                  :barclaycard_gpa_number,
                  :business_bank_account_name,
                  :business_bank_account_number,
                  :business_bank_sort_code,
                  :business_bank_name,
                  :campaign_code,
                  :paper_application,
                  :standard_pre_paid_offer_commission_rate,
                  :negotiated_pre_paid_offer_commission_rate,
                  :pre_approved_check_taking_place,
                  :manual_credit_check_being_undertaken,
                  :existing_barclays_relationship_being_evidenced,
                  :record_was_submitted_for_sanctions_approval,

                  :gross_annual_turnover,
                  :privacy_policy,

                  :registered_company_address_attributes,
                  :registered_company_address_id,
                  :trading_address_attributes,
                  :trading_address_id,
                  :business_address_attributes,
                  :business_address_id,
                  :business_bank_address_attributes,
                  :business_bank_address_id,
                  :billing_address_attributes,
                  :billing_address_id,

                  :user_id,
                  :user_attributes,
                  :status,

                  :customer_service_phone_number,
                  :customer_service_email_address,
                  :has_business_logo,
                  :business_logo,
                  :existing_barclays_customer,
                  :exposure_limit

  has_attached_file :business_logo

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :registered_company_address, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :trading_address, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :business_address, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :billing_address, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :business_bank_address, allow_destroy: true, reject_if: :all_blank

  monetize :gross_annual_turnover_cents

  LARGE_TURNOVER_THRESHOLD = Money.new(10000000 * 100)

  #
  # === Validations
  #
  validates :user, associated: true, allow_blank: true

  validates :business_bank_account_name, length: { minimum: 2, maximum: 30, allow_nil: true }, entity_name: true, allow_nil: true
  validates :business_bank_account_number, bank_account_number: true
  validates :contact_work_mobile_number, mobile_phone: true
  validates :contact_work_mobile_number, presence: true, if: Proc.new { |r| r.contact_work_phone_number.blank? }
  validates :contact_work_phone_number, landline_phone: true
  validates :contact_work_phone_number, presence: true, if: Proc.new { |r| r.contact_work_mobile_number.blank? }
  validates :contact_work_email_address, presence: true, email: true, encrypted_uniqueness: true
  validates :business_bank_sort_code, numericality: { greater_than: 0 }, length: { minimum: 2, maximum: 6}, allow_nil: true
  validates :contact_first_name, presence: true, length: { minimum: 2, maximum: 40 }, alpha_name: true
  validates :contact_last_name, presence: true, length: { minimum: 2, maximum: 40 }, alpha_name: true
  validates :registered_with_companies_house, inclusion: { :in => [true, false] }
  validates :business_bank_name, length: { minimum: 2, maximum: 40 }, entity_name: true, allow_nil: true
  validates :negotiated_pre_paid_offer_commission_rate, numericality: { greater_than: 0, less_than: 100 }, unless: :standard_pre_paid_offer_commission_rate?

  validate_as_bespoke_contact_title :contact_title
  validates :contact_position, length: { minimum: 2, maximum: 20 }
  validates :primary_business_category, inclusion: { in: PRIMARY_CATEGORY_KEYS }
  validates :secondary_business_category, inclusion: { in: Proc.new { |r| SECONDARY_CATEGORY_KEYS[r.primary_business_category] } }, allow_blank: true,
            if: Proc.new { |r| r.primary_business_category && PRIMARY_CATEGORY_KEYS.include?(r.primary_business_category) }
  validates :secondary_business_category, :inclusion => { :in => [nil, ''] }, if: Proc.new { |r| r.primary_business_category.blank? }
  validates :privacy_policy, acceptance: { accept: "1", message: "Please read and accept the Privacy Policy." }
  validates :business_website_url, length: { minimum: 5, maximum: 50 }, url: true, allow_blank: true

  validates :gross_annual_turnover_cents, numericality: { greater_than: 0 }

  ## Validations based on more complex validation conditions
  with_options if: Proc.new {|r| r.status == 'approved'} do |record|
    record.validates :exposure_limit, presence: true, numericality: {greater_than:0}
    record.validate :validate_merchant_owner_present_for_approval
  end

  validates :registered_company_number,
        length: { is: 8, message: "Registered Company Number has to be exactly 8 characters long" },
        format: { with: /^[(a-zA-Z|0-9)]{2}\d{6}$/, message: "Registered Company Number must be all digits, except for first 2 characters, which may be letters" },
        if: proc(&:registered_with_companies_house?)

  with_options presence: true, length: { minimum: 2, maximum: 80 } do |r|
    r.validates :registered_company_address, if: proc(&:registered_company_address_required?)
    r.validates :trading_address, if: proc(&:trading_address_required?)
    r.validates :billing_address, if: proc(&:billing_address_required?)
    r.validates :business_address, if: proc(&:business_address_required?)

    r.validates :trading_name, entity_name: true, if: proc(&:trading_name_required?)
    r.validates :registered_company_name, entity_name: true, if: proc(&:registered_company_name_required?)
    r.validates :business_name, entity_name: true, if: proc(&:business_name_required?)
  end

  validates :existing_barclays_customer, inclusion: { :in => [true, false] }
  validate :validate_status_transition
  validate :only_one_name_present
  validates :legal_representative, acceptance: { accept: true, message: "Please confirm that you are the legal representative." , allow_nil: false}

  #
  # === Validation conditions
  #
  def only_one_name_present
    if business_name.present? && registered_company_name.present?
      errors.add(:business_name, "can't be set if registered company name is set")
      errors.add(:registered_company_name, "can't be set if business name is set")
    end
  end

  def validate_merchant_owner_present_for_approval
    return if self.merchant_owners.size > 0
    unless self.existing_barclays_customer || self.registered_with_companies_house || self.barclaycard_gpa_merchant
      errors.add(:merchant_owners, "A merchant owner is required")
    end
  end

  def registered_company_name_required?
    registered_with_companies_house?
  end

  def registered_company_address_required?
    registered_with_companies_house?
  end

  def trading_name_required?
    registered_with_companies_house? && !trading_name_is_registered_company_name?
  end

  def trading_address_required?
    registered_with_companies_house? && !trading_address_is_registered_company_address?
  end

  def business_name_required?
    !registered_company_name_required?
  end

  def business_address_required?
    !registered_with_companies_house?
  end

  def billing_address_required?
    if registered_with_companies_house?
      !billing_address_is_registered_company_address? && !billing_address_is_trading_address?
    else
      !billing_address_is_business_address?
    end
  end

  validates :customer_service_email_address, email: true, allow_blank: true
  validates :customer_service_phone_number, landline_phone: true, allow_blank: true

  with_options :if => :has_offers? do |merchant|
    merchant.validates :customer_service_email_address, email: true, presence: true
    merchant.validates :customer_service_phone_number, landline_phone: true, presence: true
  end

  def has_offers?
    offers.count > 0
  end

  #
  # === Callbacks
  #
  before_validation :format_contact_work_phone_numbers
  before_validation :prepend_http_scheme_to_business_website_url_if_missing
  before_validation :set_trading_name
  after_validation :add_errors_on_gross_annual_turnover_cents_to_gross_annual_turnover

  before_create :assign_uuid, :set_accepted_privacy_policy_at
  before_save :remove_address_id_for_nil_addresses

  scope :submitted, where(status: ['submitted']).order('barclaycard_gpa_merchant DESC', 'updated_at ASC')
  scope :non_submitted, where(status: ['approved','declined','suspended']).order('barclaycard_gpa_merchant DESC', 'updated_at ASC','status')

  def self.for_validation
    self.submitted + self.non_submitted
  end

  def self.new_by_sales_person
    new(
      registered_with_companies_house: true,
      trading_name_is_registered_company_name: true,
      trading_address_is_registered_company_address: true,
      billing_address_is_registered_company_address: true,
      billing_address_is_trading_address: true,
      billing_address_is_business_address: true,
      barclaycard_gpa_merchant: true,
      legal_representative: true,
      standard_pre_paid_offer_commission_rate: true
    )
  end

  def self.transitions
    {
      nil => ['draft', 'pending signature'],
      'draft' =>  ['pending signature'],
      'pending signature' => ['cancelled', 'submitted'],
      'submitted' => ['approved','approved','declined'],
      'approved' => ['approved','declined','suspended'],
      'declined' => ['approved','declined','suspended'],
      'suspended' => ['approved','declined','suspended']
    }
  end

  def display_name
    self.registered_with_companies_house? ? self.registered_company_name : self.business_name
  end

  def draft?
    # TODO Remove db lookup when we have a proper state machine. Currently this method is used in forms and has to 
    # support saves with validation failures and in-memory status changes that were not made in the db, the db status is used.
   self.new_record? ? true : [nil, 'draft'].include?(Merchant.find(self.id).status)
  end

  def pending_signature?
    # TODO Remove db lookup when we have a proper state machine. Currently this method is used in forms and has to 
    # support saves with validation failures and in-memory status changes that were not made in the db, the db status is used.
   self.new_record? ? false : Merchant.find(self.id).status == 'pending signature'
  end

  def valid_transition?(old_status, new_status)
    Merchant.transitions[old_status].try(:include?, new_status)
  end

  def validate_status_transition
    if status_changed? && !valid_transition?(status_change[0], status_change[1])
      self.errors.add(:status, "Invalid status change #{status_change.inspect}")
    end
  end

  def set_attrs_to_validate_on_save(attributes_provided)
    # validate all user supplied attributes plus the trading_name.  Don't validate
    # privacy_policy because it has to be true and the admin user may not want to set it.
    self.attrs_to_validate = (attributes_provided.select{ |k,v| v.present?}.keys.map(&:to_sym) +
      [:trading_name] - [:privacy_policy, :legal_representative]).uniq
  end

  def valid_contact_titles
    Bespoke::Contact::TITLES
  end

  def large?
    gross_annual_turnover >= LARGE_TURNOVER_THRESHOLD
  end

  def small?
    !large?
  end

  def decline_validation
    self.status = 'declined'
  end

  def approve_validation
    self.status = 'approved'
  end

  def suspend
    self.status = 'suspended'
  end

  def self.search(page = nil, options = nil)
    options ||= {}
    page ||= {}
    page[:page] = 1 unless page.key?(:page) && page[:page].present?
    page[:per_page] = 25 unless page.key?(:per_page) && page[:per_page].present?
    page.merge!(order: 'registered_company_name') unless page.key?(:order) && page[:order].present?
    query = Merchant.where("1 = 1")
    query = query.where("status LIKE ?", options[:status]) if options.key?(:status) && options[:status].present?
    if options.key?(:name) && options[:name].present?
      name_param = "#{options[:name]}%"
      query = query.where('(registered_company_name LIKE ?) or (trading_name LIKE ?) or (business_name LIKE ?)', name_param, name_param, name_param)
    end
    query = query.joins("LEFT OUTER JOIN addresses on addresses.id = business_address_id").
                  where('addresses.postcode is not null and addresses.postcode like ?', "#{options[:post_code]}%") if options.key?(:post_code) && options[:post_code].present?
    query.paginate(page)
  end

  def pre_paid_offer_commission_rate
    standard_pre_paid_offer_commission_rate ? 50 : negotiated_pre_paid_offer_commission_rate
  end

  def needs_customer_service_contact_details?
    customer_service_phone_number.blank? || customer_service_email_address.blank?
  end

  private

  def assign_uuid
    self.uuid ||= UUID.new.generate
  end

  def set_accepted_privacy_policy_at
    self.privacy_policy_accepted_at = Time.zone.now
  end

  def format_contact_work_phone_numbers
    contact_work_mobile_number.gsub!(/\D/, "") if contact_work_mobile_number
    contact_work_phone_number.gsub!(/\D/, "") if contact_work_phone_number
  end

  def prepend_http_scheme_to_business_website_url_if_missing
    return if business_website_url.blank?
    begin
      uri = URI.parse business_website_url
    rescue URI::InvalidURIError
      return
    end
    self.business_website_url = "http://#{business_website_url}" if uri.scheme.blank?
  end

  def add_errors_on_gross_annual_turnover_cents_to_gross_annual_turnover
    errors[:gross_annual_turnover_cents].each do |error|
      errors.add(:gross_annual_turnover, error)
    end
  end

  def set_trading_name
    unless trading_name.present?
      self.trading_name = registered_company_name.presence || business_name
    end
  end

  def remove_address_id_for_nil_addresses
    self.billing_address_id = nil if address_is_getting_destroyed?(self.billing_address)
    self.registered_company_address_id = nil if address_is_getting_destroyed?(self.registered_company_address)
    self.trading_address_id = nil if address_is_getting_destroyed?(self.trading_address)
    self.business_address_id = nil if address_is_getting_destroyed?(self.business_address)
    self.business_bank_address_id = nil if address_is_getting_destroyed?(self.business_bank_address)
  end

  def address_is_getting_destroyed?(ref)
    ref.present? && ref.destroyed?
  end

end
