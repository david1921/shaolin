class AddChooseOwnOfferImageToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :choose_own_offer_image, :boolean, default: false
  end
end
