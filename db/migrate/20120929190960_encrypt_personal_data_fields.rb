class EncryptPersonalDataFields < ActiveRecord::Migration
  def up
    change_table "addresses" do |t|
      t.rename_encrypted_forward  "address_line_1"
      t.rename_encrypted_forward  "address_line_2"
      t.rename_encrypted_forward  "address_line_3"
      t.rename_encrypted_forward  "address_line_4"
      t.rename_encrypted_forward  "address_line_5"
      t.rename_encrypted_forward  "post_town"
    end

    change_table "info_requests" do |t|
      t.rename_encrypted_forward  "title"
      t.rename_encrypted_forward  "first_name"
      t.rename_encrypted_forward  "last_name"
      t.rename_encrypted_forward  "business_name"
      t.rename_encrypted_forward  "email"
      t.rename_encrypted_forward  "additional_details"
      t.rename_encrypted_forward  "telephone"
    end

    change_table "merchant_owners" do |t|
      t.rename_encrypted_forward  "first_name"
      t.rename_encrypted_forward  "last_name"
      t.rename_encrypted_forward  "home_address"
      t.rename_encrypted_forward  "title"
    end

    change_table "merchants" do |t|
      t.rename_encrypted_forward  "contact_title"
      t.rename_encrypted_forward  "contact_first_name"
      t.rename_encrypted_forward  "contact_last_name"
      t.rename_encrypted_forward  "contact_work_phone_number"
      t.rename_encrypted_forward  "contact_work_mobile_number"
      t.rename_encrypted_forward  "contact_work_email_address"
      t.rename_encrypted_forward  "business_bank_account_name"
      t.rename_encrypted_forward  "business_bank_account_number"
      t.rename_encrypted_forward  "business_bank_sort_code"
      t.rename_encrypted_forward  "business_bank_name"
    end

    change_table "users" do |t|
      t.rename_encrypted_forward  "email"
      t.rename_encrypted_forward  "username"
      t.rename_encrypted_forward  "first_name"
      t.rename_encrypted_forward  "last_name"
    end
  end

  def down
    change_table "addresses" do |t|
      t.rename_encrypted_reverse  "address_line_1"
      t.rename_encrypted_reverse  "address_line_2"
      t.rename_encrypted_reverse  "address_line_3"
      t.rename_encrypted_reverse  "address_line_4"
      t.rename_encrypted_reverse  "address_line_5"
      t.rename_encrypted_reverse  "post_town"
    end

    change_table "info_requests" do |t|
      t.rename_encrypted_reverse  "title"
      t.rename_encrypted_reverse  "first_name"
      t.rename_encrypted_reverse  "last_name"
      t.rename_encrypted_reverse  "business_name"
      t.rename_encrypted_reverse  "email"
      t.rename_encrypted_reverse  "additional_details"
      t.rename_encrypted_reverse  "telephone"
    end

    change_table "merchant_owners" do |t|
      t.rename_encrypted_reverse  "first_name"
      t.rename_encrypted_reverse  "last_name"
      t.rename_encrypted_reverse  "home_address"
      t.rename_encrypted_reverse  "title"
    end

    change_table "merchants" do |t|
      t.rename_encrypted_reverse  "contact_title"
      t.rename_encrypted_reverse  "contact_first_name"
      t.rename_encrypted_reverse  "contact_last_name"
      t.rename_encrypted_reverse  "contact_work_phone_number"
      t.rename_encrypted_reverse  "contact_work_mobile_number"
      t.rename_encrypted_reverse  "contact_work_email_address"
      t.rename_encrypted_reverse  "business_bank_account_name"
      t.rename_encrypted_reverse  "business_bank_account_number"
      t.rename_encrypted_reverse  "business_bank_sort_code"
      t.rename_encrypted_reverse  "business_bank_name"
    end

    change_table "users" do |t|
      t.rename_encrypted_reverse  "email"
      t.rename_encrypted_reverse  "username"
      t.rename_encrypted_reverse  "first_name"
      t.rename_encrypted_reverse  "last_name"
    end
  end
end

class ActiveRecord::ConnectionAdapters::Table
  def rename_encrypted(name)
    rename name, "encrypted_#{name}"
  end

  def rename_encrypted_forward(name)
    rename name, "encrypted_#{name}"
  end

  def rename_encrypted_reverse(name)
    rename "encrypted_#{name}", name
  end
end
