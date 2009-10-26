#!/usr/bin/env ruby
 
require 'rubygems'
require 'httparty'
require 'json'
require 'pp'
 
#A spotify-api API client.
class Spotify
  include HTTParty
  
  base_uri 'localhost:3000'
  
  def self.get_or_bail(path, params={})
    resp = get(path, :query=>params)
    raise resp.inspect if resp["status"] != "OK"
    resp["result"]
  end
  
  def self.artists(name)
    get_or_bail("/artists", {:name => name})
  end
  
  def self.tracks(name, artist=nil)
    q = { :name => name }
    q.merge!(:artist=>artist) if artist    
    get_or_bail("/tracks", q)
  end
  
  def self.albums(name, artist=nil)
    q = { :name => name }
    q.merge!(:artist=>artist) if artist
    get_or_bail("/albums", q)
  end
  
  def self.playlist(id)
    get_or_bail("/playlists", :id=>id)
  end
  
  def self.playlists
    get_or_bail("/playlists")
  end

  def self.update_playlist(playlist_id, name=nil, track_ids=[])  
    data = {}
    data["tracks"] = track_ids.map { |t_id| { 'id' => t_id } } unless track_ids.empty?
    data["name"]   = name if name
    
    resp = put("/playlists/#{playlist_id}", :body => data.to_json)
    raise resp.inspect if resp['status'] != 'OK'
  end
  
  def self.create_playlist(name, track_ids=[])
    resp = post("/playlists", :body => {      
       :name => name,
       :tracks => track_ids.map { |id| { 'id' => id } }
     }.to_json)
     
    if resp.code == 201
      location = resp.headers['location']
      "201 created (#{location})"
    else
      raise resp.inspect
    end
  end
  
  def self.resolve(tracks)
    tracks.map do |(title, artist)|
      begin
        Spotify.tracks(title, artist).first
      rescue RuntimeError
        nil
        #raise
      end
    end.flatten.compact
  end
end

if __FILE__ == $0
  if ARGV.empty?
    STDERR.puts "#{$0} [list|create|search]"
    exit(1)
  end
  
  pp case cmd = ARGV.shift
    when "list"
      Spotify.playlists
    when "create"
      raise ArgumentError, "#{$0} create <name>" unless name = ARGV.shift        
      Spotify.create_playlist(name)
    when "search"
      raise ArgumentError, "#{$0} search <what>" unless what = ARGV.shift      
      Spotify.albums(what)
    else raise ArgumentError, "invalid command: #{cmd}"
  end  
end