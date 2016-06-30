module Offers
  module Validation
    extend ActiveSupport::Concern
    include SelectiveValidation::Base

    ATTRS_TO_VALIDATE_FROM_DRAFT_STEP = {
      0 => [
        :user,
        :merchant,
        :status,
        :step
      ],
      1 => [
        :type,
        :objective,
        :primary_category,
        :secondary_category,
        :earliest_start_date,
        :duration,
        :latest_marketable_date
      ],
      2 => [
        :title,
        :description,
        :original_price,
        :bespoke_price,
        :maximum_vouchers,
        :voucher_expiry,
#       :earliest_redemption,
        :redemption_website_url,
        :redemption_phone_number,
        :stores,
        :library_image,
        :full_redemption,
        :new_customers,
        :no_shows_cancellations_forfeit_voucher,
        :non_transferrable,
        :one_per_transaction_per_visit,
        :use_own_vouchers, 
        :choose_own_offer_image,
        :phone
      ],
      3 => [
        :target_all,
        :target_age_ranges,
        :target_genders,
        :target_annual_incomes,
        :target_distance_from_location,
        :target_spend_per_transaction_with_merchant,
        :target_spend_per_transaction_in_sector,
        :target_spend_frequency_per_week_with_merchant,
        :target_spend_frequency_per_week_in_sector,
        :allow_social_media_sharing,
        :pricing_attestation,
        :capacity_attestation,
        :claims_attestation,
        :permissions_attestation
      ],
      4 => [
        :key_information_agreements_attributes
      ]
    }.with_indifferent_access

    ATTRS_TO_VALIDATE_FROM_DRAFT_STEP.inject([]) do |memo, (key, val)|
      ATTRS_TO_VALIDATE_FROM_DRAFT_STEP[key] = val.concat(memo).freeze
    end

    ATTRS_TO_VALIDATE_FROM_STATUS = {
      'pending signature' => [
        :negotiated_pre_paid_offer_commission_rate,
        :pricing_attestation,
        :claims_attestation,
        :permissions_attestation,
        :capacity_attestation
      ],
      'submitted' => [
      ]
    }.with_indifferent_access

    ATTRS_TO_VALIDATE_FROM_STATUS.inject(ATTRS_TO_VALIDATE_FROM_DRAFT_STEP.values.last) do |memo, (key, val)|
      ATTRS_TO_VALIDATE_FROM_STATUS[key] = val.concat(memo).freeze
    end

    
  end
end
