#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'jotify'

describe Jotify::Media do
  
  describe "an artist" do
    before do
      @artist = Jotify::Media::Artist.new
    end
    
    it "should implement to_h" do
      @artist.respond_to?(:to_h).should be_true
    end
  end
  
  describe "a track" do
    before do
      @track = Jotify::Media::Track.new
    end
    
    it "should implement to_h" do
      @track.respond_to?(:to_h).should be_true
    end      
  end
  
  describe "an album" do
    before do
      @album = Jotify::Media::Album.new
    end
    
    it "should implement to_h" do
      @album.respond_to?(:to_h).should be_true      
    end
    
    it "should implement enumerable" do
      @album.class.included_modules.should include(Enumerable)
    end            
  end
  
  describe "a result" do
    before do 
      @result = Jotify::Media::Result.new
    end
    
    it "should implement to_h" do
      @result.respond_to?(:to_h).should be_true      
    end
    
    it "should implement enumerable" do
      @result.class.included_modules.should include(Enumerable)
      @result.respond_to?(:each).should be_true
    end
  end
  
  describe "playlists" do    
    it "should implement enumerable" do
      p = Jotify::Media::Playlist.new
      p.class.included_modules.should include(Enumerable)
      p.respond_to?(:each).should be_true
      10.times { p.tracks.add(Jotify::Media::Track.new) }
      p.to_a.size.should == 10      
    end
  end
  
  describe "playlist container" do
    before do
      @container = Jotify::Media::PlaylistContainer.new
    end
    
    it "should implement enumerable" do
      @container.respond_to?(:each).should be_true    
      @container.class.included_modules.should include(Enumerable)        
    end
  end
  
end