class AddBusinessRegistrationNumberToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :business_registration_number, :string 
  end
end
