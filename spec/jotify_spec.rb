#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'jotify'

describe Jotify do  
  
  it "should resolve ids" do    
    { "spotify:user:flumix:playlist:2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "http://open.spotify.com/user/flumix/playlist/2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "2mnbxTkghYtlHMdX3jdP9C" => "4d921ebcdd8c80f32ce1ed5acafbb9c8",
      "4d921ebcdd8c80f32ce1ed5acafbb9c8" => "4d921ebcdd8c80f32ce1ed5acafbb9c8"
    }.each { |id, expected| Jotify.resolve_id(id).should == expected }
  end
end