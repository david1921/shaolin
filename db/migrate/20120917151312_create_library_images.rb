class CreateLibraryImages < ActiveRecord::Migration
  def change
    create_table :library_images do |t|
      t.attachment :photo
      t.integer :position
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end
end
