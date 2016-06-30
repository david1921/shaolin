class AddStatusAndCreatedByToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :status, :string
    add_column :offers, :user_id, :integer
  end
end
