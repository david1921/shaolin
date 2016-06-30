class AddCompaniesHouseRegistrationNumberToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :companies_house_registration_number, :string
  end
end
