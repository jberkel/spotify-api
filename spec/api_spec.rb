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
      res = Jotify::Result.new
      res.artists.add(Jotify::Artist.new('4d921ebcdd8c80f32ce1ed5acafbb9c8', 'The Kinks'))
      @jotify.stub!(:search).and_return(res)
      get '/artists', :name=>'The Kinks'
      last_response.should be_ok
      json_response.should == {"status"=>"OK", "result"=>
        [{"id"=>"4d921ebcdd8c80f32ce1ed5acafbb9c8", "popularity"=>0.0, "url"=>"http://open.spotify.com/artist/2mnbxTkghYtlHMdX3jdP9C", "name"=>"The Kinks"}]
      }
    end      
    
    it "should return an error message if no name is specified" do
      lambda { get '/artists' }.should raise_error(ArgumentError)
    end
  end
  
  describe "/tracks" do
     it "searches by track name" do
       res = Jotify::Result.new
       res.tracks.add(Jotify::Track.new('4d921ebcdd8c80f32ce1ed5acafbb9c8'))
       @jotify.stub!(:search).and_return(res)
       get '/tracks', :name=>'Waterloo Sunset'
       last_response.should be_ok
       json_response.should == {"status"=>"OK", "result"=>
         [{"id"=>"4d921ebcdd8c80f32ce1ed5acafbb9c8", "popularity"=>0.0, "url"=>"http://open.spotify.com/track/2mnbxTkghYtlHMdX3jdP9C", "title"=>nil, "artist"=>nil, "album"=>nil}]
       }
     end
           
     it "should return an error message if no name is specified" do
       lambda { get '/tracks' }.should raise_error(ArgumentError)
     end
  end
  
  describe "/albums" do
    it "searches by album name" do
      res = Jotify::Result.new
      res.albums.add(Jotify::Album.new('4d921ebcdd8c80f32ce1ed5acafbb9c8', 
      'Something Else', 
      Jotify::Artist.new('4d921ebcdd8c80f32ce1ed5acafbb9c8', 'The Kinks')))
      
      @jotify.stub!(:search).and_return(res)
      get '/albums', :name=>'Something Else'
      last_response.should be_ok
      json_response.should == {"status"=>"OK", "result"=>
        [{"id"=>"4d921ebcdd8c80f32ce1ed5acafbb9c8",
          "popularity"=>0.0, 
          "url"=>"http://open.spotify.com/album/2mnbxTkghYtlHMdX3jdP9C", 
          "name"=>"Something Else", 
          "artist"=>"The Kinks", "year"=>-1, "type"=>nil}]
      }
    end      
    
    it "should return an error message if no name is specified" do
      lambda { get '/albums' }.should raise_error(ArgumentError)
    end    
  end
  
  describe "/playlists" do
    before do 
      #String id, String name, String author, boolean collaborative
      @playlist = Jotify::Playlist.new("4d921ebcdd8c80f32ce1ed5acafbb9c8", "my shiny playlist", "test", false)
    end
      
    describe "get" do  
      
      it "should get all playlists created by the user" do
        @jotify.should_receive(:playlists).and_return( [@playlist] )
        get '/playlists'
        last_response.should be_ok
        json_response.should == {"status"=>"OK",
          "result"=> { 
            "playlists" => [
              "id"=>"4d921ebcdd8c80f32ce1ed5acafbb9c8",
              "url"=>"http://open.spotify.com/user/test/playlist/2mnbxTkghYtlHMdX3jdP9C",                     
              "name"=>"my shiny playlist",
              "tracks"=>[], "author"=>"test", "revision"=>-1, "collaborative"=>false
            ] 
          }
        }
      end
      
      
      it "should retrieve a playlist by id" do
        @jotify.should_receive(:playlist).with("4d921ebcdd8c80f32ce1ed5acafbb9c8").and_return(@playlist)
        get '/playlists/4d921ebcdd8c80f32ce1ed5acafbb9c8'
        last_response.should be_ok
        json_response.should == {"status"=>"OK",
         "result"=>{
            "id"=>"4d921ebcdd8c80f32ce1ed5acafbb9c8",
            "url"=>"http://open.spotify.com/user/test/playlist/2mnbxTkghYtlHMdX3jdP9C",                     
            "name"=>"my shiny playlist",
            "tracks"=>[], "author"=>"test", "revision"=>-1, "collaborative"=>false}
        }
      end
    
      it "should except a base62 string as id" do
        @jotify.should_receive(:playlist).with("2mnbxTkghYtlHMdX3jdP9C").and_return(@playlist)
        get '/playlists/2mnbxTkghYtlHMdX3jdP9C'
        last_response.should be_ok
      end
    
      it "should return 404 for non-existing playlist" do
        @jotify.should_receive(:playlist).with("unknown").and_return(nil)
        get '/playlists/unknown'
        last_response.status.should == 404
        json_response.should == {"status"=>"ERROR", "message"=>"playlist not found"}
      end
    end
    
    
    describe "create/update" do
      it "should create a playlist when posting to /playlists" do
        @jotify.should_receive(:create_playlist).with('my shiny playlist', true).and_return(@playlist)
        post '/playlists', :name => 'my shiny playlist', :collaborative => 'true'
        last_response.status.should == 201
        last_response.headers['Location'].should == 'http://open.spotify.com/user/test/playlist/2mnbxTkghYtlHMdX3jdP9C'
      end
    
      it "should update playlist when putting to /playlists/id" do
        @jotify.should_receive(:playlist).with("foo").and_return(@playlist)
        @jotify.should_receive(:add_tracks_to_playlist).with(@playlist, ['1','2']).and_return(true)
        put '/playlists/foo', { 'tracks' => [ {'id'=>'1' }, { 'id'=>'2' } ] }.to_json
        last_response.should be_ok
        json_response.should == {'status'=>'OK', 'message'=>'successfully added 2 tracks'}
      end
      
      it "should return 404 if playlist to update cannot be found" do
        @jotify.should_receive(:playlist).with("foo").and_return(nil)
        put '/playlists/foo', { 'tracks' => [ {'id'=>'1' }, { 'id'=>'2' } ] }.to_json
        last_response.status.should == 404
        json_response.should == {"status"=>"ERROR", "message"=>"playlist not found"} 
      end
      
      it "should return 500 if playlist could not be updated" do
        @jotify.should_receive(:playlist).with("foo").and_return(@playlist)
        @jotify.should_receive(:add_tracks_to_playlist).with(@playlist, ['1','2']).and_return(false)
        put '/playlists/foo', { 'tracks' => [ {'id'=>'1' }, { 'id'=>'2' } ] }.to_json
        last_response.status.should == 500
        json_response.should == {"status"=>"ERROR", "message"=>"could not add to playlist"}         
      end
            
      it "should return 403 if invalid data is supplied" do
        @jotify.should_receive(:playlist).with("foo").and_return(@playlist)
        lambda { put '/playlists/foo', { 'foo' => 'bar' }.to_json }.should raise_error(ArgumentError)
      end
      
      it "shouldn't do anything if no track ids supplied" do
        @jotify.should_receive(:playlist).with("foo").and_return(@playlist)
        put '/playlists/foo', { 'tracks' => [] }.to_json
        last_response.should be_ok
      end
    end
  end
end