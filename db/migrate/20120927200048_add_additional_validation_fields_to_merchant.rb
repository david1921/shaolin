class AddAdditionalValidationFieldsToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :existing_barclays_customer, :boolean, default: false
    add_column :merchants, :exposure_limit, :integer
  end
end
