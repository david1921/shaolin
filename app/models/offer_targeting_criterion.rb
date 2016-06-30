class OfferTargetingCriterion < ActiveRecord::Base
  TARGET_AGE_RANGES = %w(18-34 35-55 55+)
  TARGET_GENDERS = %w(male female)
  TARGET_ANNUAL_INCOMES = %w(0-20000 20000-40000 40000+)
  TARGET_DISTANCES_FROM_LOCATION = %w(Low Low/Medium)
  TARGET_SPEND_PER_TRANSACTION_WITH_MERCHANT = %w(0-5 5-20 20+)
  TARGET_SPEND_PER_TRANSACTION_IN_SECTOR = %w(0-5 5-20 20+)
  TARGET_SPEND_FREQUENCY_PER_WEEK_WITH_MERCHANT = %w(0 1-2 3+)
  TARGET_SPEND_FREQUENCY_PER_WEEK_IN_SECTOR = %w(0 1-2 3+)

  self.table_name = "offer_targeting_criteria"

  attr_accessible :offer_id, :criterion_type, :value

  module TYPES
    GENDER = "gender"
    AGE = "age"
    ANNUAL_INCOME = "income"
    DISTANCE_FROM_LOCATION = "distance"
    SPEND_PER_TRANSACTION_WITH_MERCHANT = "spend_per_merchant_tx"
    SPEND_PER_TRANSACTION_IN_SECTOR = "spend_per_tx_in_sector"
    SPEND_FREQUENCY_PER_WEEK_WITH_MERCHANT = "weekly_merchant_spend_freq"
    SPEND_FREQUENCY_PER_WEEK_IN_SECTOR = "weekly_sector_spend_freq"
  end

  belongs_to :offer
  validates :offer_id, :criterion_type, :value, presence: true
end
