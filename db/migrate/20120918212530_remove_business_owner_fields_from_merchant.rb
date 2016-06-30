class RemoveBusinessOwnerFieldsFromMerchant < ActiveRecord::Migration
  def up
    remove_column :merchants, :business_owner_name, :business_owner_post_code, :business_owner_house_name_number,
                              :business_owner_address_1, :business_owner_address_2, :business_owner_address_3,
                              :business_owner_address_4, :business_owner_address_5, :business_registration_number
    rename_column :merchants, :company_reistered_number, :company_registered_number
  end

  def down
    change_table :merchants do |t|
      t.string :business_owner_name
      t.string :business_owner_post_code
      t.string :business_owner_house_name_number
      t.string :business_owner_address_1
      t.string :business_owner_address_2
      t.string :business_owner_address_3
      t.string :business_owner_address_4
      t.string :business_owner_address_5
      t.string :business_registration_number
      t.rename :company_registered_number, :company_reistered_number
    end
  end
end
