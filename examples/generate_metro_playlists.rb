#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[lastfm])
require File.join(File.dirname(__FILE__), *%w[spotify])

unique = true  # prefer unique tracks
metro_areas = [
  ["Berlin", "Germany"],
  ["London", "United Kingdom"],
  ["Barcelona", "Spain"],
  ["Paris", "France"],
  ["Rome", "Italy"],
  ["Los Angeles", "United States"],
  ["Istanbul", "Turkey"],
  ["Vienna", "Austria"],
  ["Zurich", "Switzerland"],
  ["New York", "United States"],
  ["Oslo", "Norway"],
  ["Stockholm", "Sweden"],
]

def fetch_existing_playlists
  puts "fetching existing playlists"
  Spotify.playlists['playlists'].inject({}) do |h, p|
    if p['name'] =~ /chart for ([\w\s]+), ([\w\s]+) (\([\d-]+\))\Z/
      city, metro = $1, $2    
      h[[city, metro]] = p['id']
    end
    h
  end
end

existing_playlists = {} # fetch_existing_playlists

metro_areas.each do |(metro, country)|
  puts "fetching last.fm tracks for #{metro}, #{country}"  
  tracks = LastFM.metro_track_chart(metro, country, unique)  
  spotify_tracks = Spotify.resolve(tracks.map { |t| [t["name"], t["artist"]["name"]] })
  
  next if spotify_tracks.empty?
  
  if playlist_id = existing_playlists[[metro, country]]
    puts "update existing playlist #{playlist_id} with #{spotify_tracks.size} tracks"
    puts Spotify.update_playlist(playlist_id, nil, spotify_tracks.map { |t| t['id'] })
  else
    tstamp = Time.new.strftime("%m-%d-%Y")
    puts "creating new playlist with #{spotify_tracks.size} tracks"
    puts Spotify.create_playlist("chart for #{metro}, #{country} (#{tstamp})", spotify_tracks.map { |t| t['id'] })  
  end
end