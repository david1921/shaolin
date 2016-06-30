class RenameRegistrationsToMerchants < ActiveRecord::Migration
  def up
    rename_table :registrations, :merchants
  end

  def down
    rename_table :merchants, :registrations
  end
end
