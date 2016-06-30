class AddGrossAnnualTurnoverToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :gross_annual_turnover_cents, :integer
  end
end
