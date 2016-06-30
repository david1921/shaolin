module BrowserTests
  module Screenshots

    def self.included(base)
      base.send :include, InstanceMethods
      base.class_eval do
        setup :setup_screenshots
      end
    end

    module InstanceMethods
      def setup_screenshots
        @save_screenshots = ENV["SCREENSHOTS"].present?
        if @save_screenshots && ENV["CAPYBARA_DRIVER"].blank?
          Capybara.default_driver = Capybara.javascript_driver
          say_if_verbose "Defaulting to Capybara.javascript_driver for screenshots (set ENV['CAPYBARA_DRIVER'] to override)"
        end
      end

      def screenshot!(name)
        return unless @save_screenshots

        if captured_screenshot?(name)
          say_if_verbose "screenshot => #{name} (exists)"
        else
          capture_screenshot!(name)
        end
      end


      private

      def saved_screenshots
        @@saved_screenshots ||= {}
      end

      def captured_screenshot?(name)
        saved_screenshots.has_key?(name)
      end

      def capture_screenshot!(name)
        saver = Capybara::Screenshot::Saver.new(Capybara, Capybara.page, false, name)
        saver.save
        saved_screenshots[name] = true
        say_if_verbose "screenshot => #{saver.screenshot_path}"
      end
    end
  end
end
