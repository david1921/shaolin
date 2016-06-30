class RemovePricingTypeFromOffers < ActiveRecord::Migration
  def up
    remove_column :offers, :pricing_type
  end

  def down
    add_column :offers, :pricing_type, :string
  end
end
