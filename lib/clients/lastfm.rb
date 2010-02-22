#!/usr/bin/env ruby
 
require 'rubygems'
require 'httparty'
 
#Last.fm API client, implemented 
#using httparty (http://github.com/jnunemaker/httparty/)
#
#NOTE: you need to set the LAST_FM_API_KEY environment variable to your API key
#before you can use this class.
class LastFM
  include HTTParty
 
  base_uri 'ws.audioscrobbler.com'
  default_params :api_key => (ENV['LAST_FM_API_KEY'] or raise "You need to set the LAST_FM_API_KEY environment variable")
 
  class <<self 
    def loved_tracks(user_id, limit=5)
      if tracks = query('user.getLovedTracks', :user=>user_id, :limit=>limit)['lovedtracks']['track']

        [tracks].flatten.map do |r|
          { 'artist' => r['artist']['name'], 'title'=>r['name'], 'mbid' => r['mbid'] } 
        end
      else
        []
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

    def friends(user_id)
      query('user.getfriends', :user=>user_id, :recenttracks=>false)['friends']['user']
    end

    def neighbours(user_id, max=10)
      query('user.getneighbours', :user=>user_id, :limit=>10)#['friends']['user']
    end
    
    # retrieve tracks recently loved by friends
    def friends_loved_tracks(user_id, limit=5)
      friends(user_id).inject({}) do |h, u|
        h[u['name']] = loved_tracks(u['name'], limit)
        sleep 0.5
        h
      end
    end
    
    def metro_weekly_chartlist
      query("geo.getMetroWeeklyChartlist")['weeklychartlist']['chart'].reverse
    end

    def metro_track_chart(city, country, unique=false, from=nil, to=nil)
      args = { :country=>country, :metro=>city }      
      args.merge!(:start=>from, :end=>to) if from && to
        
      res = query("geo.getMetro#{unique ? 'Unique' : ''}TrackChart", args)
      return [] unless res['toptracks'] && res['toptracks']['track']
      res['toptracks']['track']
    end
  
    def query(method, args={})
     result = get("/2.0/", :query => { :method => method }.merge(args))
     raise result['lfm']['error'] if result['lfm'] && result['lfm']['status'] == 'failed'
     result['lfm']
    end

  end
end
