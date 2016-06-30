class AddUseOwnVouchersToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :use_own_vouchers, :boolean, default: false
  end
end
