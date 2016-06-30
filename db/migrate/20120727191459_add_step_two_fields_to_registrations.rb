class AddStepTwoFieldsToRegistrations < ActiveRecord::Migration
  def change
    change_table :registrations do |t|
      t.column :primary_business_category, :string
      t.column :campaign_code, :string
      t.column :has_online_store, :boolean
      t.column :has_mail_order, :boolean
      t.column :business_website, :string
      t.column :business_bank_account_name, :string
      t.column :business_bank_account_number, :string
      t.column :business_bank_sort_code, :string
      t.column :authorised_by_first_name, :string
      t.column :authorised_by_last_name, :string
      t.column :authorised_by_position, :string
      t.column :authorised_by_phone_number, :string
      t.column :authorised_by_mobile_number, :string
      t.column :authorised_by_email_address, :string
    end
  end
end
