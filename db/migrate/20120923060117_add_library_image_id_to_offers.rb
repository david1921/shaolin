class AddLibraryImageIdToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :library_image_id, :integer
  end
end
