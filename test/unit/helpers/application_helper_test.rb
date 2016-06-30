require_relative '../../../test/test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context '#landing_page?' do
    should 'be false if not on the root page' do
      request = stub(path: admin_merchants_path)
      self.stubs(:request).returns(request)
      assert !landing_page?
    end

    should 'be true if on the root page' do
      request = stub(path: root_path)
      self.stubs(:request).returns(request)
      assert landing_page?
    end
  end

  context '#render_eu_cookie_message' do
    context 'without a cookie' do
      context 'on the landing page' do 
        should 'render a banner' do
          self.stubs(:eu_cookie?).returns(false)
          self.stubs(:landing_page?).returns(true)
          assert_not_nil render_eu_cookie_message
        end
      end

      context 'not on the landing page' do 
        should 'not render a banner' do
          self.stubs(:eu_cookie?).returns(false)
          self.stubs(:landing_page?).returns(false)
          assert_nil render_eu_cookie_message
        end
      end
    end

    context 'with a cookie' do
      context 'on the landing page' do
        should 'not render a banner' do
          self.stubs(:eu_cookie?).returns(true)
          self.stubs(:landing_page?).returns(true)
          assert_nil render_eu_cookie_message
        end
      end
      
      context 'not on the landing page' do
        should 'not render a banner' do
          self.stubs(:eu_cookie?).returns(true)
          self.stubs(:landing_page?).returns(false)
          assert_nil render_eu_cookie_message
        end
      end
    end
  end
end

