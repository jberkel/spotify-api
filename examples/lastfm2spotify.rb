#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[lastfm])
require File.join(File.dirname(__FILE__), *%w[spotify])

# a demo app which grabs tracks from last.fm and creates a spotify 
# playlist based on friends loved tracks
if __FILE__ == $0
  username = ARGV.shift or raise "#{$0} <username>"
  
  puts "fetching last.fm tracks (friends/recently_loved)"
  tracks = LastFM.friends_loved_tracks(username).values.flatten
  
  puts "resolving spotify ids"
  tracks = tracks.map do |track|
    Spotify.tracks(track["title"], track["artist"]).first
  end.flatten.compact
  
  #puts "found tracks: #{tracks.inspect}"
  puts "creating playlist with #{tracks.size} tracks"
  puts Spotify.create_playlist(username, tracks.map { |t| t['id'] })  
end
