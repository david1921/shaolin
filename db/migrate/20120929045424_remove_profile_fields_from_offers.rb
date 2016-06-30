class RemoveProfileFieldsFromOffers < ActiveRecord::Migration
  def up 
    remove_column :offers, :customer_service_email
    remove_column :offers, :customer_service_phone
  end

  def down
    add_column :offers, :customer_service_email, :string
    add_column :offers, :customer_service_phone, :string
  end
end
