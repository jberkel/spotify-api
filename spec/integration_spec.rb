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
      result.should be_a(Jotify::Media::Result)
      
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
  

  describe "playlists" do
    
    before do
      @playlists = @jotify.playlists
      @playlists.should_not be_empty
    end
    
    it "should return name and id, not tracks (GH-3)" do
      @playlists.each do |pl|
        puts pl.inspect
        pl.name.should_not be_nil
       
        pl.tracks.each do |t|
          t.getId().should_not be_nil
          t.getName().should be_nil
        end
      end      
    end
  end
  
end