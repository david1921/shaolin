module BrowserTests
  module AuthenticationHelper
    def sign_in(*args)
      login, password = args[0].is_a?(User) ? [args[0].username, args[0].password] : args
      visit '/sign_in'
      screenshot!('sign_in')
      fill_in ' login', with: login
      fill_in ' Password', with: password
      click_on 'Sign in'
      raise 'Sign in failed' if current_path_is_sign_in?
    end

    def sign_out
      visit '/logout'
    end

    private

    def current_path_is_sign_in?
      current_path =~ /sign_in|session/
    end
  end
end