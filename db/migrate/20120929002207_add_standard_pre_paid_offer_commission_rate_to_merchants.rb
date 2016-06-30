class AddStandardPrePaidOfferCommissionRateToMerchants < ActiveRecord::Migration
  def change
    change_table :merchants do |t|
      t.boolean :standard_pre_paid_offer_commission_rate
    end
  end
end
