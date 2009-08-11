#!/usr/bin/env ruby
 
require 'rubygems'
require 'httparty'
 
#A demo Last.fm API client, implemented 
#using httparty (http://github.com/jnunemaker/httparty/)
class Lastfm
  include HTTParty
 
  base_uri 'ws.audioscrobbler.com'
  default_params :api_key => "PUT_API_KEY_HERE"
 
  class <<self 
    def loved_tracks(user_id)
      query('user.getLovedTracks', :user=>user_id, :limit=>10)['lovedtracks']['track'].map do |r|
          { 'artist' => r['artist']['name'], 'title'=>r['name'], 'mbid' => r['mbid'] }
      end
    end
 
    def recent_tracks(user_id)
      query('user.getRecentTracks', :user=>user_id, :limit=>100)['recenttracks']['track'].map do |r|
          { 'artist' => r['artist'], 'title'=>r['name'], 'mbid' => r['mbid'] }
      end
    end

    def top_tracks(user_id, period='overall')
      unless ['overall', '7day', '3month', '6month', '12month'].include?(period)
        raise ArgumentError, "invalid period"
      end
       
      query('user.getTopTracks', :period=>period, :user=>user_id)['toptracks']['track'].map do |r|
        { 'artist' => r['artist']['name'], 'title'=>r['name'], 'mbid' => r['mbid'] }
      end
    end
  
    def query(method, args={})
     result = get("/2.0/", :query => { :method => method }.merge(args))
     raise result['lfm']['error'] if result['lfm'] && result['lfm']['status'] == 'failed'
     result['lfm']
    end
  end
end