class CreateDieselClearanceUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string   :email
      t.string   :username
      t.string   :first_name
      t.string   :last_name
      t.boolean  :active, :default => true
      t.boolean  :system
      t.boolean  :admin
      t.boolean  :sales
      t.string   :encrypted_password, :limit => 128
      t.string   :salt,               :limit => 128
      t.string   :confirmation_token, :limit => 128
      t.string   :remember_token,     :limit => 128
      t.timestamps
    end

    add_index :users, :email
    add_index :users, :remember_token
  end

  def self.down
    drop_table :users
  end
end
