class AddPrivacyPolicyAcceptedAtToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :privacy_policy_accepted_at, :datetime
  end
end
