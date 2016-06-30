class RemovePrivacyPolicyFromInfoRequest < ActiveRecord::Migration
  def up
    remove_column :info_requests, :privacy_policy_accepted_at
  end

  def down
    add_column :info_requests, :privacy_policy_accepted_at, :datetime
  end
end
