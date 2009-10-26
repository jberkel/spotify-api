#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[lastfm])
require File.join(File.dirname(__FILE__), *%w[spotify])

# a demo app which grabs tracks from last.fm and creates a spotify 
# playlist based on tracks popular in a city
if __FILE__ == $0
  city = ARGV.shift or raise "#{$0} <city,country>"

  metro,country = *city.split(',')
  
  puts "fetching last.fm tracks for #{metro}, #{country}"
  unique = true
  tracks = LastFM.metro_track_chart(metro,country, unique)
  
  puts "resolving spotify ids"
  spotify_tracks = Spotify.resolve(tracks.map { |t| [t["name"], t["artist"]["name"]] })
  
  if spotify_tracks.size > 0
    #puts "found tracks: #{spotify_tracks.inspect}"
    puts "creating playlist with #{spotify_tracks.size} tracks"
    puts Spotify.create_playlist("chart for #{metro}, #{country}", spotify_tracks.map { |t| t['id'] })  
  end
end
