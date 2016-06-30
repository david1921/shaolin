class AddVoucherCodeAndImageRelatedFlagsToOffers < ActiveRecord::Migration
  def change
    change_table :offers do |offers|
      offers.column :use_merchant_supplied_voucher_code, :boolean
      offers.column :use_merchant_supplied_image, :boolean
    end
  end
end
