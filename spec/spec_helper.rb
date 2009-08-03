require 'rubygems'
require 'spec'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods  
end
