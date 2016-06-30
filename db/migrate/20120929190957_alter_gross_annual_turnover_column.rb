class AlterGrossAnnualTurnoverColumn < ActiveRecord::Migration
  def change
    change_column :merchants, :gross_annual_turnover_cents, :integer, :limit => 8
  end
end
