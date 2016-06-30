class AddMerchantIdToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :merchant_id, :integer
  end
end
