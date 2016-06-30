# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork' do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('test/test_helper.rb') { :test_unit }
  watch('test/factories.rb')
end
