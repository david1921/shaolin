class AddAttestionFlagsToOffers < ActiveRecord::Migration
  ATTESTATIONS = [:pricing_attestation, :capacity_attestation, :claims_attestation, :permissions_attestation]

  def up
    change_table :offers do |offers|
      ATTESTATIONS.each do |at|
        offers.boolean at, default: true
      end
    end
  end

  def down
    ATTESTATIONS.each do |at|
      remove_column :offers, at
    end
  end
end
