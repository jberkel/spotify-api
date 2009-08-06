require 'rubygems'
require 'spec'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods  
end


module Helpers
  def spotify_hex_id
    '4d921ebcdd8c80f32ce1ed5acafbb9c8'
  end
  
  def spotify_uri
    '2mnbxTkghYtlHMdX3jdP9C'
  end
  
  def empty_playlist
    Jotify::Media::Playlist.new
  end
  
  def empty_track
    Jotify::Media::Track.new
  end
  
  def empty_album
    Jotify::Media::Album.new
  end
end

Spec::Example::ExampleMethods.send(:include, Helpers)


