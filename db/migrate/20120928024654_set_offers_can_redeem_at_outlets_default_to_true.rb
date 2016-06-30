class SetOffersCanRedeemAtOutletsDefaultToTrue < ActiveRecord::Migration
  def up
    change_column :offers, :can_redeem_at_outlets, :boolean, null: false, default: true
  end

  def down
    change_column :offers, :can_redeem_at_outlets, :boolean, null: true, default: nil
  end
end
