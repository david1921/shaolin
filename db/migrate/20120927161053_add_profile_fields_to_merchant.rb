class AddProfileFieldsToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :customer_service_phone_number, :string
    add_column :merchants, :customer_service_email_address, :string
    add_column :merchants, :business_logo_indicator, :boolean
    add_attachment :merchants, :business_logo
  end
end
