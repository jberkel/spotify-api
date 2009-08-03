require File.join(File.dirname(__FILE__), 'spec_helper')

require 'jotify'

describe Jotify do
  
  
  it "should resolve ids" do    
    Jotify.resolve_id("spotify:user:flumix:playlist:2mnbxTkghYtlHMdX3jdP9C").should ==("4d921ebcdd8c80f32ce1ed5acafbb9c8")
    Jotify.resolve_id("http://open.spotify.com/user/flumix/playlist/2mnbxTkghYtlHMdX3jdP9C").should ==("4d921ebcdd8c80f32ce1ed5acafbb9c8")
    Jotify.resolve_id("2mnbxTkghYtlHMdX3jdP9C").should ==("4d921ebcdd8c80f32ce1ed5acafbb9c8")
    Jotify.resolve_id("4d921ebcdd8c80f32ce1ed5acafbb9c8").should ==("4d921ebcdd8c80f32ce1ed5acafbb9c8")        
  end
  
end