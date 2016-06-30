class AddBelongsToIndexes < ActiveRecord::Migration
  def change
    add_index :offer_targeting_criteria, :offer_id
    add_index :offers, :merchant_id
    add_index :stores, :merchant_id
  end
end
