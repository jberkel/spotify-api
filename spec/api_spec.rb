#!/usr/bin/env jruby -S spec
require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rack/test'
require 'jotify'
require 'api'

require 'sinatra'
set :environment, :test

describe 'Api' do
  
  def app() Sinatra::Application end
  
  def json_response
    last_response.content_type.should == 'application/json'      
    JSON.parse(last_response.body)    
  end
  
  before do  
    @jotify = jotify = mock('Jotify')
    Sinatra::Application.send(:define_method, :jotify) { jotify }
  end
  
  describe "/artists" do
    it "searches by artist name" do
      @jotify.stub!(:search).and_return(Jotify::Result.new)
      get '/artists', :name=>'The Kinks'
      last_response.should be_ok
      json_response.should == {"status"=>"OK", "result"=>[]}
    end      
    
    it "should return an error message if no name is specified" do
      lambda { get '/artists' }.should raise_error(ArgumentError)
    end
  end
  
  describe "/tracks" do
     it "searches by track name" do
       @jotify.stub!(:search).and_return(Jotify::Result.new)
       get '/tracks', :name=>'Waterloo Sunset'
       last_response.should be_ok
       json_response.should == {"status"=>"OK", "result"=>[]}
     end
           
     it "should return an error message if no name is specified" do
       lambda { get '/tracks' }.should raise_error(ArgumentError)
     end
  end
  
  describe "/albums" do
    it "searches by album name" do
      @jotify.stub!(:search).and_return(Jotify::Result.new)
      get '/albums', :name=>'Something Else'
      last_response.should be_ok
      json_response.should == {"status"=>"OK", "result"=>[]}
    end      
    
    it "should return an error message if no name is specified" do
      lambda { get '/albums' }.should raise_error(ArgumentError)
    end    
  end
  
  describe "/playlists" do
    before do 
      #String id, String name, String author, boolean collaborative
      @playlist = Jotify::Playlist.new("4d921ebcdd8c80f32ce1ed5acafbb9c8", "my playlist", "test", false)
    end
      
    it "retrieves a playlist by id" do

      @jotify.should_receive(:playlist).with("4d921ebcdd8c80f32ce1ed5acafbb9c8").and_return(@playlist)
      get '/playlists/4d921ebcdd8c80f32ce1ed5acafbb9c8'
      last_response.should be_ok
      json_response.should == {"status"=>"OK",
       "result"=>{
          "id"=>"4d921ebcdd8c80f32ce1ed5acafbb9c8",
          "url"=>"http://open.spotify.com/user/test/playlist/2mnbxTkghYtlHMdX3jdP9C",                     
          "name"=>"my playlist",
          "tracks"=>[], "author"=>"test", "revision"=>-1, "collaborative"=>false}
      }
    end
    
    it "should except a base62 string as id" do
      @jotify.should_receive(:playlist).with("2mnbxTkghYtlHMdX3jdP9C").and_return(@playlist)
      get '/playlists/2mnbxTkghYtlHMdX3jdP9C'
    end
    
  end
end