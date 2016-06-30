class RemoveUuidFromOffers < ActiveRecord::Migration
  def change
    remove_column :offers, :uuid
  end
end
