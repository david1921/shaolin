class AddMissingOffersFieldsForAdminAndSalesPortals < ActiveRecord::Migration
  def up
    add_column :offers, :can_redeem_online, :boolean
    add_column :offers, :redemption_website_url, :string
    add_column :offers, :can_redeem_by_phone, :boolean
    add_column :offers, :redemption_phone_number, :string
    add_column :offers, :can_redeem_at_outlets, :boolean
    add_column :offers, :allow_social_media_sharing, :boolean
  end

  def down
    remove_column :offers, :can_redeem_online
    remove_column :offers, :redemption_website_url
    remove_column :offers, :can_redeem_by_phone
    remove_column :offers, :redemption_phone_number
    remove_column :offers, :can_redeem_at_outlets
    remove_column :offers, :allow_social_media_sharing
  end
end
