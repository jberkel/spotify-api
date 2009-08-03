require 'rubygems'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "spotify-api"
    gem.summary = "an api for spotify, based on jotify"
    gem.email = "jan.berkel@gmail.com"
    gem.homepage = "http://github.com/jberkel/spotify-api"
    gem.description = "an api for spotify, based on jotify"
    gem.authors = ["Jan Berkel"]
    gem.add_dependency "rack"
    gem.add_dependency "sinatra"
    gem.add_dependency "json-jruby"    
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end


# Rake::TestTask.new do |t|
#   t.libs << "lib"
#   t.test_files = FileList['test/*_test.rb']
#   t.verbose = true
# end
  
