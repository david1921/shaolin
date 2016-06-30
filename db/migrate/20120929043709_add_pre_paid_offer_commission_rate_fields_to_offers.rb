class AddPrePaidOfferCommissionRateFieldsToOffers < ActiveRecord::Migration
  def change
    change_table :offers do |t|
      t.boolean  "standard_pre_paid_offer_commission_rate", :default => true
      t.decimal  "negotiated_pre_paid_offer_commission_rate", :precision => 10, :scale => 0
    end
  end
end
