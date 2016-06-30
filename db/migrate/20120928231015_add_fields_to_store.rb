class AddFieldsToStore < ActiveRecord::Migration
  def change
    add_column :stores, :name, :string
    add_column :stores, :email_address, :string
    add_column :stores, :phone_number, :string
    add_column :stores, :opening_hours, :string
  end
end
