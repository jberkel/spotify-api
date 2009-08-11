#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[lastfm])
require File.join(File.dirname(__FILE__), *%w[spotify])

# a demo app which grabs tracks from last.fm and creates a spotify 
# playlist
if __FILE__ == $0
  username = ARGV.shift or raise "#{$0} <username> [period=overall|7day|3month|6month|12month]"
  period   = ARGV.shift || '7day'
  
  puts "fetching last.fm tracks (period=#{period})"
  tracks = Lastfm.top_tracks(username, period).map do |track|
    Spotify.tracks(track["title"], track["artist"]).first
  end.flatten.compact
  
  #puts "found tracks: #{tracks.inspect}"
  puts "creating playlist with #{tracks.size} tracks"
  puts Spotify.create_playlist(username, tracks.map { |t| t['id'] })  
end