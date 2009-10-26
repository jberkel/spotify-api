#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), *%w[lastfm])
require File.join(File.dirname(__FILE__), *%w[spotify])
require 'json'

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
  Spotify.playlists['playlists'].inject({}) do |h, p|
    if p['name'] =~ /chart for ([\w\s]+), ([\w\s]+) (\([\d-]+\))\Z/
      city, metro = $1, $2    
      h[[city, metro]] = p
    end
    h
  end
end

def generate_playlists(areas, update=false, unique=true)
  puts "fetching existing playlists"
  existing_playlists = fetch_existing_playlists  
  time_period = LastFM.metro_weekly_chartlist.first
        
  areas.each do |(metro, country)|
    if existing_playlists[[metro, country]] && !update
      puts "#{metro}, #{country} already exists, skipping"
      next
    end
    
    puts "fetching last.fm tracks for #{metro}, #{country}"  
    tracks = LastFM.metro_track_chart(metro, country, unique, time_period['from'], time_period['to'])  
    puts "resolving spotify ids"
    spotify_tracks = Spotify.resolve(tracks.map { |t| [t["name"], t["artist"]["name"]] })
    
    next if spotify_tracks.empty?    
    
    if playlist = existing_playlists[[metro, country]] 
      puts "update existing playlist #{playlist['id']} with #{spotify_tracks.size} tracks"
      Spotify.update_playlist(playlist['id'], nil, spotify_tracks.map { |t| t['id'] })
    else
      tstamp = Time.new.strftime("%m-%d-%Y")
      puts "creating new playlist with #{spotify_tracks.size} tracks"
      puts Spotify.create_playlist("last.fm chart for #{metro}, #{country} (#{tstamp})", spotify_tracks.map { |t| t['id'] })  
    end
  end
end

def dump_playlists
  puts fetch_existing_playlists.values.to_json
end


if __FILE__ == $0
  if ARGV.empty?
    STDERR.puts "#{$0} [create|update|dump]"
    exit(1)
  end
  
  case cmd = ARGV.shift
    when 'update': generate_playlists(metro_areas, true)
    when 'create': generate_playlists(metro_areas)
    when 'dump': dump_playlists
    else raise ArgumentError, "invalid command #{cmd}"    
  end
end
