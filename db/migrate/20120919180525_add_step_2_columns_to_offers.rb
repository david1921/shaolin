class AddStep2ColumnsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :title, :string
    add_column :offers, :original_price_cents, :integer
    add_column :offers, :bespoke_price_cents, :integer
    add_column :offers, :pricing_type, :string
    add_column :offers, :maximum_vouchers, :integer
    add_column :offers, :description, :string
    add_column :offers, :customer_service_email, :string
    add_column :offers, :customer_service_phone, :string
    add_column :offers, :earliest_redemption, :date
    add_column :offers, :voucher_expiry, :date
    add_column :offers, :website_url, :string
    add_column :offers, :phone, :string

    add_column :offers, :full_redemption, :boolean
    add_column :offers, :new_customers, :boolean
    add_column :offers, :no_shows_cancellations_forfeit_voucher, :boolean
    add_column :offers, :one_per_transaction_per_visit, :boolean
    add_column :offers, :non_transferrable, :boolean
    add_column :offers, :additional_restrictions, :text

    create_table :offers_stores do |t|
      t.integer :store_id, null: false
      t.integer :offer_id, null: false
    end

    add_index :offers_stores, :offer_id
    add_index :offers_stores, :store_id
  end
end
