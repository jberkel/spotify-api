#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'jotify'

# WARNING: these specs need a valid spotify (premium) account, otherwise they will fail
describe "Integration" do
  
  before(:all) do
    @jotify = Jotify.new
  end
  
  after(:all) do
    @jotify.close rescue nil
  end
    
  describe "searching" do
    it "should return a result for a search" do
      result = @jotify.search("artist:Air")
      result.should be_a(Jotify::Result)
      
      result.artists.should_not be_empty      
      most_popular = result.artists.to_a.sort(&Jotify::ByPopularity).first
      most_popular.name.should == 'Air'

      result = @jotify.search("album:Moon Safari")
      result.albums.should_not be_empty
      most_popular = result.albums.to_a.sort(&Jotify::ByPopularity).first
      most_popular.name.should == 'Moon Safari' 
      most_popular.artist.name.should == 'Air'
    end
  end
  
end