class AddLockVersionToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :lock_version, :integer, :default => 0
  end
end
