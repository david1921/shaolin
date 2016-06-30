class AddAddressAndBankNameAndAddressToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :address_postcode, :string
    add_column :registrations, :address_premises_name, :string
    add_column :registrations, :address_premises_number, :string
    add_column :registrations, :business_bank_name, :string
    add_column :registrations, :business_bank_address, :string
  end
end
