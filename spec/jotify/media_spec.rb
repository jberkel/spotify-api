#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'jotify'

describe Jotify::Media do
  
  describe "an artist" do
    before do
      @artist = Jotify::Media::Artist.new(spotify_hex_id)
    end
    
    it "should implement to_h" do
      @artist.to_h.should == {:id=>"4d921ebcdd8c80f32ce1ed5acafbb9c8", :popularity=>0.0, :url=>"http://open.spotify.com/artist/2mnbxTkghYtlHMdX3jdP9C", :name=>nil} 
    end
  end
  
  describe "a track" do
    before do
      @track = Jotify::Media::Track.new(spotify_hex_id)
    end
    
    it "should implement to_h" do
      @track.to_h.should ==  {:id=>"4d921ebcdd8c80f32ce1ed5acafbb9c8", :popularity=>0.0, :url=>"http://open.spotify.com/track/2mnbxTkghYtlHMdX3jdP9C", :title=>nil, :artist=>nil, :album=>nil} 
    end      
  end
  
  describe "an album" do
    before do
      @album = Jotify::Media::Album.new(spotify_hex_id)
    end
    
    it "should implement to_h" do
      @album.to_h.should == {:id=>"4d921ebcdd8c80f32ce1ed5acafbb9c8", :popularity=>0.0, :url=>"http://open.spotify.com/album/2mnbxTkghYtlHMdX3jdP9C", :name=>nil, :artist=>nil, :year=>-1, :type=>nil} 
    end
    
    it "should implement enumerable" do
      @album.class.included_modules.should include(Enumerable)
      @album.to_a.should == []
    end            
  end
  
  describe "a result" do
    before do 
      @result = Jotify::Media::Result.new
    end
    
    it "should implement to_h" do
      @result.to_h.should == {:artists=>[], :albums=>[], :tracks=>[]}
    end
    
    it "should implement enumerable" do
      @result.class.included_modules.should include(Enumerable)
      @result.respond_to?(:each).should be_true
      @result.to_a.should == []
      @result.inspect.should == "{:artists=>[], :albums=>[], :tracks=>[]}"
    end
  end
  
  describe "playlists" do    
    before(:each) do
      @p = Jotify::Media::Playlist.new
    end
    
    it "should implement enumerable, size, inspect" do
      @p.class.included_modules.should include(Enumerable)
      @p.respond_to?(:each).should be_true
      10.times { @p.tracks.add(Jotify::Media::Track.new) }
      @p.size.should == 10      
    end
    
    it "should implement inspect" do
      @p.inspect.should == "[Playlist:  ]" 
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
      @container.to_a.should == []   
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