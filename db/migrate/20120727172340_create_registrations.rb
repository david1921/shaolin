class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :business_registered_name
      t.string :business_trading_name
      t.string :business_phone_number
      t.string :business_mobile_number
      t.string :business_email_address
      t.string :contact_title
      t.string :contact_first_name
      t.string :contact_last_name
      t.string :contact_position
      t.string :password

      t.timestamps
    end
  end
end
