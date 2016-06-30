require_relative '../test_helper'

class SeedDataTest < ActiveSupport::TestCase

  context "Production Seed" do
    should "run without errors" do
      assert (load "#{Rails.root}/db/seeds.rb") , "should not raise errors"
    end

    should "have seed the database w/ one system user" do
      load "#{Rails.root}/db/seeds.rb"
      system_user = User.find_by_username("system")
      assert !system_user.nil?, "should not be nil"
    end

  end

end
