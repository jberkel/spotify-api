require 'java'
require File.join(File.dirname(__FILE__), '..', 'jars', 'jotify.jar')

class Jotify
  Result = Java::DeFelixbrunsJotifyMedia::Result
  Playlist = Java::DeFelixbrunsJotifyMedia::Playlist
  
  ByPopularity = Proc.new { |a,b| b.popularity <=> a.popularity }
  
  [:playlists, :close, :search].each do |m|
    define_method(m) do |*args|
      @jotify.send(m, *args)
    end
  end

  def initialize
    @jotify  = Java::DeFelixbrunsJotify::JotifyPool.new
    settings = Java::DeFelixbrunsJotifyGuiUtil::JotifyPreferences.getInstance()
    settings.load()

    username = settings.getString("login.username")
    password = settings.getString("login.password")
    @jotify.login(username, password)

    at_exit do
      @jotify.close rescue nil
    end

    if block_given?
      begin
        yield self
      ensure
        close
      end
    end
  end

  def resolve_tracks(tracks)
    found = []
    tracks.each do |(artist, track)|
      res = search("artist:#{artist} track:#{track}")
      found << res.tracks.to_a.first unless res.tracks.empty?
     end
    found
  end

  def add_playlist_from_q(q)
    res = search(q)
    if res.tracks.size > 0
      pl = @jotify.playlistCreate("query: #{q}", false)
      raise "could not create playlist" unless pl
      @jotify.playlistAddTracks(pl, res.tracks, 0)
      add_playlist(pl)
      pl
    else
      nil
    end
  end

  def add_playlist(id)
    @jotify.playlistsAddPlaylist(@jotify.playlists, id.is_a?(Java::DeFelixbrunsJotifyMedia::Playlist) ? id : playlist(id))
  end

  def self.resolve_id(id)
    #spotify:user:jberkel:playlist:3b51h4mgc5089F4JUR7mqC
    case id
      when /\Ahttp:\/\/open\.spotify\.com/: id[id.rindex('/')+1..-1].to_hex
      when /spotify:/: id[id.rindex(':')+1..-1].to_hex
      when /\A[0-9a-f]{32}\Z/: id
      when /\A[a-zA-Z0-9]{22}\Z/: id.to_hex
    else 
      raise "invalid id: #{id}"
    end
  end

  def playlist(id)
    plist = @jotify.playlist(Jotify.resolve_id(id))
    res = @jotify.browse(plist.getTracks())
    res.tracks.each_with_index do |t,i|
      plist.getTracks().set(i, t)
    end
    plist
  end
end

class String
  def to_hex
    Java::DeFelixbrunsJotifyUtil::SpotifyURI.to_hex(self)
  end

  def to_spotify_uri
    Java::DeFelixbrunsJotifyUtil::SpotifyURI.toURI(self)
  end
end

class Java::DeFelixbrunsJotifyMedia::Playlist
  def inspect
    "[Playlist: #{self.getId().to_spotify_uri} #{getTracks.to_a}]"
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
end

class Java::DeFelixbrunsJotifyMedia::Media
  def inspect
    self.to_s
  end  
  
  def to_h
    h = { :id=>self.getId(), :popularity=> popularity }
    h[:url] = self.link if self.respond_to?(:link)
    h
  end
end

class Java::DeFelixbrunsJotifyMedia::Track
  def to_h
     super.merge(:title=>title, :artist=>artist.name, :album=>album.name)
  end
end

class Java::DeFelixbrunsJotifyMedia::Artist
  def to_h
     super.merge(:name=>name)
  end
end

class Java::DeFelixbrunsJotifyMedia::Album
  def to_h
    super.merge(:name=>a.name, :artist=>artist.name, :year=>year, :type=>type)
  end
end