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
  
  def error(code, message)
    [code, { 'status' => 'ERROR', 'message' => message }.to_json]
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
      end.each { |h| 
        h['size'] = h.delete(:tracks).size
      }
    }
  }.to_json
end

Sinatra::Application.get('/playlists/:id') do
  content_type :json  
  playlist = begin
    jotify.playlist(params[:id])
  rescue Exception => e
    return error(500, "error getting playlist: #{e.message}")
  end
  
  if playlist
    {
      'status'=>'OK',
      'result'=>playlist.to_h
    }.to_json
  else
    error(404, 'playlist not found')
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
        return error(500, 'playlist created but tracks could not be added')
      end
    end
    redirect playlist.link, 201 # created
  else
    error(500, 'playlist could not be created')
  end
end

Sinatra::Application.put('/playlists/:id') do
  content_type :json
    
  playlist = begin
    jotify.playlist(params[:id])
  rescue Exception => e
    return error(500, "error getting playlist: #{e.to_s}")
  end
  
  return error(404, 'playlist not found') unless playlist
  body = request.body.read
  data = JSON.parse(body)
  
  raise ArgumentError, "invalid format" unless data.is_a?(Hash)
  
  if data.has_key?('name') && data['name'] != playlist.name
    unless jotify.rename_playlist(playlist, data['name'])
      return error(500, 'could rename playlist')
    end
  end
  
  if data.has_key?('collaborative') && data['collaborative'] != playlist.collaborative?
    unless jotify.set_collaborative_flag(playlist, data['collaborative'])
      return error(500, 'could not change collaborative flag')
    end
  end
  
  if data['tracks'].is_a?(Array)
    ids  = data['tracks'].map { |t| t['id'] }
    begin
      unless jotify.set_tracks_on_playlist(playlist, ids)
        return error(500, 'could not update tracks')
      end  
    rescue Exception => e
      return error(500, e.to_s)
    end
    
  end
  return 200, { 'status' => 'OK', 'message' => "update successful" }.to_json
end


if __FILE__ == $0
  Sinatra::Application.run! 
end
