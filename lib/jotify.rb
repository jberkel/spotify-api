require 'java'
require File.join(File.dirname(__FILE__), '..', 'jars', 'jotify.jar')

class Jotify
  Playlist = Java::DeFelixbrunsJotifyMedia::Playlist  
  Result = Java::DeFelixbrunsJotifyMedia::Result
  Track = Java::DeFelixbrunsJotifyMedia::Track    
  Artist = Java::DeFelixbrunsJotifyMedia::Artist    
  Album = Java::DeFelixbrunsJotifyMedia::Album
  Preferences = Java::DeFelixbrunsJotifyGuiUtil::JotifyPreferences    
  SpotifyURI = Java::DeFelixbrunsJotifyUtil::SpotifyURI
  
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
    pl = @jotify.playlistCreate(name, collaborative)
    return nil unless pl
    add_playlist(pl)
    pl
  end
    
  def add_playlist(id)
    @jotify.playlistsAddPlaylist(@jotify.playlists, id.is_a?(Java::DeFelixbrunsJotifyMedia::Playlist) ? id : playlist(id))
  end
     
  def add_tracks_to_playlist(playlist, track_ids)
    tracks = Java::JavaUtil::ArrayList.new
    track_ids.each { |id| tracks.add(Track.new(Jotify.resolve_id(id))) }
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
    prefs = Preferences.getInstance()
    prefs.load()
    { 
     :username => prefs.getString("login.username"),
     :password => prefs.getString("login.password")
    }       
  end
   
  def self.credentials=(creds)
    prefs = Preferences.getInstance()
    prefs.load()
    prefs.setString("login.username", creds[:username])
    prefs.setString("login.password", creds[:password])
    prefs.save() or raise "could not save login details"
  end
end

class Java::DeFelixbrunsJotifyMedia::PlaylistContainer
  include Enumerable
  def each(&block) playlists.each(&block) end
end

class Java::DeFelixbrunsJotifyMedia::Playlist
  include Enumerable  
  def each(&block) tracks.each(&block) end
    
  def inspect
    "[Playlist: #{self.getId()} #{getTracks.to_a}]"
  end
  
  def to_h
    {
      :id => getId(),
      :name=> name,
      :url => link,
      :tracks => tracks.map { |t| t.to_h },
      :author => author,
      :revision => revision,
      :collaborative => collaborative
    }
  end
end

class Java::DeFelixbrunsJotifyMedia::Result
  def inspect
    { :artists=>self.artists.to_a, :albums=>self.albums.to_a, :tracks=>self.tracks.to_a }.inspect
  end  
  
  def to_h
    { 
      :artists => self.artists.map { |a| a.to_h },
      :albums => self.albums.map { |a| a.to_h },
      :tracks => self.tracks.map { |t| t.to_h }
    }
  end
end

class Java::DeFelixbrunsJotifyMedia::Media
  def inspect
    self.to_s
  end  
  
  def to_h
    h = { :id=>self.getId(), :popularity=> popularity.nan? ? 0.0 : popularity.to_f }
    h[:url] = self.link if self.respond_to?(:link)
    h
  end
end

class Java::DeFelixbrunsJotifyMedia::Track
  def to_h
    super.merge(:title=>title, :artist=>artist ? artist.name : nil, :album=>album ? album.name : nil)
  end
end

class Java::DeFelixbrunsJotifyMedia::Artist
  def to_h
    super.merge(:name=>name)
  end
end

class Java::DeFelixbrunsJotifyMedia::Album
  def to_h
    super.merge(:name=>name, :artist=>artist ? artist.name : nil, :year=>year, :type=>type)
  end
end
