class CreateKeyInformationAgreements < ActiveRecord::Migration
  def change
    create_table :key_information_agreements do |t|
      t.belongs_to :merchant, :null => false
      t.binary :gzipped_html
      t.timestamps
    end
    add_attachment :key_information_agreements, :signature
    add_index :key_information_agreements, :merchant_id
  end
end
