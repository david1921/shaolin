class AddStepToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :step, :integer, default: 1
  end
end
