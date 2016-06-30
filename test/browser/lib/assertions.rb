module BrowserTests
  module Assertions
    def assert_has_content(content)
      assert page.has_content?(content), "Expected page to have content \"#{content}\", but it does not." 
    end
    def assert_has_element(selector)
      assert page.has_selector?(selector), "Expected page to have element matching \"#{selector}\", but it does not." 
    end
  end
end