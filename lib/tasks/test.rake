require 'rake/testtask'
require 'tasks/phantomjs_task'

# Sets up the rake task, called test.  Which runs all the unit, functional and integration tests
Rake::TestTask.new(:test => "test:prepare") do |t|
  t.test_files = FileList[
    'test/unit/**/*_test.rb', 
    'test/no_rails/**/*_test.rb', 
    'test/functional/**/*_test.rb', 
    'test/integration/**/*_test.rb', 
    'test/view/**/*_test.rb'
  ]
  t.verbose = false
  t.warning = false
end

# Sets up each of the individual rake tasks for the tests:
#   test:unit
#   test:functional
#   test:integration
#   test:no_rails
#   test:browser
#   test:view
%w( unit functional integration no_rails browser view).each do |name|
  Rake::TestTask.new("test:#{name}") do |t|
    t.pattern = "test/#{name}/**/*_test.rb"
    t.verbose = false
    t.warning
  end
end

task "test:all" => ["test", "test:javascript", "test:browser"]

# Runs the performance tests, ruby-perf is required to run
Rake::TestTask.new("test:performance" => :environment) do |t|
  t.pattern = 'test/performance/*_test.rb'
  t.verbose = false
  t.warning = false
end

namespace :test do

  desc "Run javascripts"
  task :javascript do
    runner = Tasks::Test::PhantomJSTask.new
    runner.check_dependencies
    runner.run
  end

end

# `rake` => `rake test`
desc "Run tests"
task :default => "test:all"
