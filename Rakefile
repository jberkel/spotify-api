require 'rubygems'
require 'rake/testtask'
require 'spec/rake/spectask'

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


Spec::Rake::SpecTask.new do |t|
  t.rcov = false
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.libs << "./lib"
end
