require 'jquery-rails'

module Tasks
  module Test
    class PhantomJSTask

      DEFAULT_TEST_RUNNER = File.expand_path("../../test/javascript/testrunner.js", File.dirname(__FILE__))
      DEFAULT_TEST_SCRIPT = File.expand_path("../../test/javascript/index.html", File.dirname(__FILE__))

      attr_accessor :test_runner, :test_script

      def initialize(test_runner=DEFAULT_TEST_RUNNER, test_script=DEFAULT_TEST_SCRIPT)
        @test_runner = test_runner
        @test_script = test_script
      end

      def run
        puts "Running javascript tests\n\n"
        result = system("phantomjs #{test_runner} file://#{test_script}")
        fail "\nSome Javascript tests failed." unless result
      end

      def check_dependencies
        ensure_phantomjs_installed
        ensure_test_runner_exists
        ensure_test_script_exists
        check_jquery_version_match
      end


      private

      def ensure_test_script_exists
        fail "unable to find qunit index.html, looked in: #{test_script}" unless File.exists?(test_script)
      end

      def ensure_test_runner_exists
        fail "unable to find testrunner.js, looked in: #{test_runner}" unless File.exists?(test_runner)
      end

      def check_jquery_version_match
        fail "jQuery version used in tests (#{jquery_test_version}) does not match jquery-rails gem version of JQuery (#{jquery_app_version})" unless jquery_test_version == jquery_app_version
      end

      def jquery_test_version
        lib_path = File.expand_path("../../test/javascript/lib", File.dirname(__FILE__))
        jquery_file_regex = /^jquery-(.*)\.js$/
        jquery_file = Dir.new(lib_path).entries.select { |e| e =~ jquery_file_regex }[0] or fail "Couldn't find jquery library used for the tests. Looked in: #{lib_path}"
        jquery_file_regex.match(jquery_file)[1]
      end

      def jquery_app_version
        Jquery::Rails::JQUERY_VERSION
      end

      def ensure_phantomjs_installed
        fail <<phantomjs_msg unless system("which phantomjs > /dev/null 2>&1")
**************************************************************************
Looks like phantomjs is not installed or not in your path.
The easiest way to install phantomjs is to use home brew, and run:

   brew install phantomjs

brew should add phantomjs to your path, if not you may need to manually
add the path to phanomjs.

See: http://phantomjs.org/
**************************************************************************
phantomjs_msg
      end
    end
  end
end