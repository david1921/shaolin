class RemoveDefaultStepValueFromOffers < ActiveRecord::Migration
  def up
    change_column_default(:offers, :step, nil)
  end

  def down
    change_column_default(:offers, :step, 1)
  end
end
