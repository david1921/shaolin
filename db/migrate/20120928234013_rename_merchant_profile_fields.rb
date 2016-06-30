class RenameMerchantProfileFields < ActiveRecord::Migration
  def change
    rename_column :merchants, :business_logo_indicator, :has_business_logo
  end
end
