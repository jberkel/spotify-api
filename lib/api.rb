require 'json'
require 'sinatra/base'

def query(what, p=what) params[p] ? "#{what}:" + params[p] : '' end

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
    'result'=> res.tracks.map do |t| 
      t.to_h
    end
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

Sinatra::Application.get('/playlists/:id') do
  content_type :json  
  playlist = jotify.playlist(params[:id])
  {
    'status'=>'OK',
    'result'=>playlist.to_h
  }.to_json
end


