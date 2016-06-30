class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :type
      t.string :primary_category
      t.string :secondary_category
      t.string :objective
      t.date :earliest_start_date
      t.integer :duration, default: 30
      t.date :latest_marketable_date
      t.string :business_bank_account_name
      t.string :business_bank_account_number
      t.string :business_bank_sort_code
      t.string :uuid
      t.timestamps
    end
  end
end
