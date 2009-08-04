require 'java'
require File.expand_path(File.dirname(__FILE__) + '/jars/jotify.jar')

class Jotify          

  module Media    
    import 'de.felixbruns.jotify.media.Playlist'
    import 'de.felixbruns.jotify.media.PlaylistContainer'    
    import 'de.felixbruns.jotify.media.Result'
    import 'de.felixbruns.jotify.media.Track'
    import 'de.felixbruns.jotify.media.Artist'
    import 'de.felixbruns.jotify.media.Album'
  end
  
  import 'de.felixbruns.jotify.gui.util.JotifyPreferences'
  import 'de.felixbruns.jotify.util.SpotifyURI'

  ByPopularity = Proc.new { |a,b| b.popularity <=> a.popularity }
  
  [:close, :search].each do |m|
    define_method(m) do |*args|
      @jotify.send(m, *args)
    end
  end

  def initialize(jotify_impl=Java::DeFelixbrunsJotify::JotifyPool.new(4))
    @jotify  = jotify_impl
    
    credentials = Jotify.credentials
    @jotify.login(credentials[:username], credentials[:password])
    
    at_exit do
      begin
        @jotify.close 
      rescue Exception => e
      end
    end

    if block_given?
      begin
        yield self
      ensure
        close
      end
    end
  end

  def playlists
    @jotify.playlists.map { |p| playlist(p.getId()) }
  end

  def playlist(id)
    playlist = @jotify.playlist(Jotify.resolve_id(id))
    unless playlist.tracks.empty?
     res = @jotify.browse(playlist.tracks)
     res.tracks.each_with_index do |t,i|
       playlist.tracks.set(i, t)
     end
    end
    playlist
  end
   
  def create_playlist(name, collaborative=false)
    playlist = @jotify.playlistCreate(name, collaborative)
    return nil unless playlist
    add_playlist(playlist)
    playlist
  end
    
  def add_playlist(id)
    @jotify.playlistsAddPlaylist(@jotify.playlists, id.is_a?(Media::Playlist) ? id : playlist(id))
  end
     
  def add_tracks_to_playlist(playlist, track_ids)
    tracks = Java::JavaUtil::ArrayList.new
    track_ids.each { |id| tracks.add(Media::Track.new(Jotify.resolve_id(id))) }
    @jotify.playlistAddTracks(playlist, tracks, 0)    
  end
  
  def self.resolve_id(id)
    case id
      when /\Ahttp:\/\/open\.spotify\.com/: SpotifyURI.to_hex(id[id.rindex('/')+1..-1])
      when /spotify:/: SpotifyURI.to_hex(id[id.rindex(':')+1..-1])
      when /\A[0-9a-f]{32}\Z/: id
      when /\A[a-zA-Z0-9]{22}\Z/: SpotifyURI.to_hex(id)
    else 
      raise "invalid id: #{id}"
    end
  end
   
  def self.credentials
    prefs = JotifyPreferences.getInstance()
    prefs.load()
    { 
     :username => prefs.getString("login.username"),
     :password => prefs.getString("login.password")
    }       
  end
   
  def self.credentials=(creds)
    prefs = JotifyPreferences.getInstance()
    prefs.load()
    prefs.setString("login.username", creds[:username])
    prefs.setString("login.password", creds[:password])
    prefs.save() or raise "could not save login details"
  end
end

require File.expand_path(File.dirname(__FILE__) + '/jotify/media')