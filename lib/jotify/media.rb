require 'java'
require File.expand_path(File.dirname(__FILE__) + '/../jars/jotify.jar')

#Make Jotify's native Java classes a bit more rubyish by implementing some mehods / modules
module Java
  module DeFelixbrunsJotifyMedia
    class Media
      def inspect
        self.to_s
      end  
  
      def to_h
        h = { :id=>self.getId(), :popularity=> popularity.nan? ? 0.0 : popularity.to_f }
        h[:url] = self.link if self.respond_to?(:link)
        h
      end
    end
  
    class Playlist
      include Enumerable  
      
      def each(&block) 
        tracks.each(&block)
      end
      
      def size
        tracks.size
      end

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
      
      def <<(track)
        tracks.add(track) if track.is_a?(Track)
      end
    end
  
    class PlaylistContainer
      include Enumerable
      
      def each(&block) 
        playlists.each(&block) 
      end
      
      def size() playlists.size end
        
      def <<(pl)
        playlists.add(pl) if pl.is_a?(Playlist)
      end
    end

    class Result
      include Enumerable
      
      def each(&block)
        artists.each(&block)
        tracks.each(&block)
        albums.each(&block)
      end
      
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
  
    class Track
      def to_h
        super.merge(:title=>title, :artist=>artist ? artist.name : nil, :album=>album ? album.name : nil)
      end
    end
  
    class Artist
      def to_h
        super.merge(:name=>name)
      end
    end

    class Album
      include Enumerable
      
      def each(&block) 
        tracks.each(&block) 
      end
        
      def to_h
        super.merge(:name=>name, :artist=>artist ? artist.name : nil, :year=>year, :type=>type)
      end
    end
  end
end


