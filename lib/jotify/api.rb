#!/usr/bin/env jruby
require 'rubygems'
require 'json'
require 'sinatra/base'
require File.expand_path(File.dirname(__FILE__) + '/../jotify') unless defined?(Jotify)
  
class Sinatra::Application
  Lock = Mutex.new
  
  def jotify
    Lock.synchronize do
      @@jotify ||= Jotify.new
    end
  end
  
  def query(what, p=what) 
    params[p] ? "#{what}:" + params[p] : '' 
  end
end

Sinatra::Application.error ArgumentError do
  content_type :json
  {
    'status' => 'ERROR',
    'message' => request.env['sinatra.error'].message
  }.to_json
end
  
Sinatra::Application.get('/tracks') do
  content_type :json
  raise ArgumentError, "need name" unless params[:name]
  
  res = jotify.search([query(:track, :name), query(:artist), query(:album)].join(' '))
  {
    'status'=>'OK', 
    'result'=> res.tracks.map { |t| t.to_h }
  }.to_json
end

Sinatra::Application.get('/albums') do
  content_type :json
  raise ArgumentError, "need name" unless params[:name]
    
  res = jotify.search([query(:album, :name), query(:artist)].join(' ') )
  {
    'status'=>'OK', 
    'result'=> res.albums.map { |a| a.to_h }
  }.to_json
end

Sinatra::Application.get('/artists') do
  content_type :json
  raise ArgumentError, "need name" unless params[:name]
  
  res = jotify.search(query(:artist, :name))
  {
    'status'=>'OK', 
    'result'=> res.artists.map { |a| a.to_h }
  }.to_json
end

Sinatra::Application.get('/playlists') do
  content_type :json
  {
    'status'=>'OK',
    'result'=> { 'playlists' => jotify.playlists.map do |p| 
        p.to_h
      end.each { |h| h.delete(:tracks) }
    }
  }.to_json
end

Sinatra::Application.get('/playlists/:id') do
  content_type :json  
  if playlist = jotify.playlist(params[:id])
    {
      'status'=>'OK',
      'result'=>playlist.to_h
    }.to_json
  else
    return 404, { 'status' => 'ERROR', 'message' => 'playlist not found' }.to_json
  end
end

Sinatra::Application.post('/playlists') do
  content_type :json
  body = request.body.read
  data = JSON.parse(body)
  playlist = jotify.create_playlist(data['name'], !!data['collaborative'])
  if playlist
    if data['tracks']
      ids  = data['tracks'].map { |t| t['id'] }
      unless jotify.set_tracks_on_playlist(playlist, ids)         
        return 500, 'status' => 'ERROR', 'message' => 'playlist created but tracks could not be added'
      end
    end
    redirect playlist.link, 201 # created
  else
    return 500, { 'status' => 'ERROR', 'message' => 'playlist could not be created' }.to_json
  end
end

Sinatra::Application.put('/playlists/:id') do
  content_type :json
  playlist = jotify.playlist(params[:id])
  
  return 404, { 'status' => 'ERROR', 'message' => 'playlist not found' }.to_json unless playlist
  body = request.body.read
  data = JSON.parse(body)
  
  raise ArgumentError, "invalid format" unless data.is_a?(Hash)
  
  if data.has_key?('name') && data['name'] != playlist.name
    unless jotify.rename_playlist(playlist, data['name'])
      return 500, { 'status' => 'ERROR', 'message' => 'could rename playlist' }.to_json
    end
  end
  
  if data.has_key?('collaborative') && data['collaborative'] != playlist.collaborative?
    unless jotify.set_collaborative_flag(playlist, data['collaborative'])
      return 500, { 'status' => 'ERROR', 'message' => 'could not change collaborative flag' }.to_json
    end
  end
  
  if data['tracks'].is_a?(Array)
    ids  = data['tracks'].map { |t| t['id'] }
    unless jotify.set_tracks_on_playlist(playlist, ids)
      return 500, { 'status' => 'ERROR', 'message' => 'could update tracks' }.to_json
    end  
  end
  return 200, { 'status' => 'OK', 'message' => "update successful" }.to_json
end


if __FILE__ == $0
  Sinatra::Application.run! 
end
