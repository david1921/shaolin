class AddElectronicallySignedToKeyInformationAgreements < ActiveRecord::Migration
  def change
    add_column :key_information_agreements, :electronically_signed, :boolean, default: false
  end
end
