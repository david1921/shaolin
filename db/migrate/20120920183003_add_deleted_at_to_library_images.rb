class AddDeletedAtToLibraryImages < ActiveRecord::Migration
  def change
    add_column :library_images, :deleted_at, :timestamp
  end
end
