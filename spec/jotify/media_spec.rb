#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), '..', 'spec_helper')
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
    before(:each) do
      @p = Jotify::Media::Playlist.new
    end
    
    it "should implement enumerable, size" do
      @p.class.included_modules.should include(Enumerable)
      @p.respond_to?(:each).should be_true
      10.times { @p.tracks.add(Jotify::Media::Track.new) }
      @p.size.should == 10      
    end
    
    it "should implement <<(track)" do
      @t = Jotify::Media::Track.new(spotify_hex_id)      
      lambda {
       @p << @t 
      }.should change(@p, :size).by(1)
      @p.to_a.first.should == @t
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
    
    it "should implement size" do
      @container.size.should == 0
    end
    
    it "should implement <<(playlist)" do
      lambda {
        2.times { @container << empty_playlist }
      }.should change(@container, :size).by(2)
    end
  end
  
end