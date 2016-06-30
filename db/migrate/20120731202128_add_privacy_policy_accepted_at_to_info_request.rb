class AddPrivacyPolicyAcceptedAtToInfoRequest < ActiveRecord::Migration
  def change
    add_column :info_requests, :privacy_policy_accepted_at, :datetime 
  end
end
