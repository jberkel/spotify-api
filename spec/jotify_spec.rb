#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'jotify'

describe Jotify do  
  
  before(:each) do
    @jotify_impl = mock('JotifyImpl')
    @jotify_impl.stub!(:login)
    @jotify = Jotify.new(@jotify_impl)
  end  
  
  it "should resolve ids" do    
    { "spotify:user:flumix:playlist:2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "http://open.spotify.com/user/flumix/playlist/2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "4d921ebcdd8c80f32ce1ed5acafbb9c8" => "4d921ebcdd8c80f32ce1ed5acafbb9c8"
    }.each { |id, expected| Jotify.resolve_id(id).should == expected }
  end
  
  it "should add tracks to playlist" do    
    @playlist = Jotify::Playlist.new
    @jotify_impl.should_receive(:playlistAddTracks) do |playlist, tracks, pos|
      playlist.should be_an(Jotify::Playlist)
      #playlist.should == @playlist
      pos.should == 0
      tracks.should be_an(Java::JavaUtil::List)
      tracks.size.should == 1
    end
    @jotify.add_tracks_to_playlist(@playlist, ['4d921ebcdd8c80f32ce1ed5acafbb9c8'])
  end    
end