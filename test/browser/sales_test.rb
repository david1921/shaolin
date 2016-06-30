require_relative 'browser_test'

class SalesTest < BrowserTest
  def setup
    @password = 'testingtesting'
    @user = create(:sales_user, :password => @password)
  end

  def test_landing_page
    assert_sales_user_starts_on_landing_page
    click_on 'Search merchants'
    assert_merchant_search_form
    assert_new_merchant_link
  end

  private

  def assert_sales_user_starts_on_landing_page
    sign_in @user.username, @password
    assert_equal landing_page_path, current_path
    screenshot!("sales_landing_page")
  end

  def assert_merchant_search_form
    fill_in 'Name', with: 'Aprisa'
    fill_in 'Post Code', with: 'M1 1AA'
    click_on 'Search'
    assert_equal '/sales/merchants', current_path
    screenshot!("sales_merchants_search")
  end

  def assert_new_merchant_link
    click_on 'New Merchant'
    assert_equal '/sales/merchants/new', current_path
    screenshot!("sales_merchants_new")
    visit landing_page_path
  end

  def landing_page_path
    '/dashboard'
  end
end
