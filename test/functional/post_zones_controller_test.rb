require_relative '../test_helper'

class PostZonesControllerTest < ActionController::TestCase
  context "with post code AB12 3XY existing" do
    setup do
      PostZone.create(:post_code => "AB123XY", :post_town => "BURNSIDE", :records => [{
        :building_number => "1",
        :thoroughfares => ["MOSS STREET"],
        :localities => ["WETWANG"]
      }, {
        :building_number => "3",
        :thoroughfares => ["MOSS STREET"],
        :localities => ["WETWANG"]
      }])
    end

    should "return JSON-encoded addresses in show for post code AB12 3XY" do
      get :show, :id => "AB12 3XY", :format => "json"
      assert_response :success

      data = JSON.parse(@response.body)
      assert_equal({"post_code"=>"AB12 3XY", "post_town"=>"BURNSIDE", "addresses"=>[["1 MOSS STREET", "WETWANG"], ["3 MOSS STREET", "WETWANG"]]}, data)
    end

    should "return JSONP-encoded addresses in show for post code AB12 3XY when a callback is specified" do
      get :show, :id => "AB12 3XY", :format => "json", :callback => "foobar"
      assert_response :success

      assert(match=/^foobar\((.*)\)$/.match(@response.body))
      data = JSON.parse(match[1])
      assert_equal({"post_code"=>"AB12 3XY", "post_town"=>"BURNSIDE", "addresses"=>[["1 MOSS STREET", "WETWANG"], ["3 MOSS STREET", "WETWANG"]]}, data)
    end
  end
end
