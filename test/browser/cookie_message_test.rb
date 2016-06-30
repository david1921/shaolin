require_relative 'browser_test'

class CookieMessageTest < BrowserTest
  setup do
    visit '/'
  end

  test "banner shows if there is no cookie" do
    assert page.has_css?("#cookiesMessageBanner")
    screenshot!('cookies_message_banner_present')
  end

  test "cookie is created if there is no cookie" do
    assert page.response_headers.key?('Set-Cookie')
    assert page.response_headers['Set-Cookie'].starts_with?('EU_COOKIE')
  end

  test "banner does not show if there a cookie" do
    visit '/'
    assert page.has_no_css?("#cookiesMessageBanner")
    screenshot!('cookies_message_banner_absent')
  end
end

