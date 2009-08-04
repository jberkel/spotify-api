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

Sinatra::Application.get('/playlists') do
  content_type :json
  playlists = jotify.playlists
  
  {
    'status'=>'OK',
    'result'=> { 'playlists' => playlists.map { |p| p.to_h } }
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
  name, collaborative = params[:name], params[:collaborative] == 'true'
  playlist = jotify.create_playlist(name, collaborative)
  if playlist
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
  raise ArgumentError, "invalid format" unless data.is_a?(Hash) && data['tracks'].is_a?(Array)
  ids  = data['tracks'].map { |t| t['id'] }
  return 200, { 'status' => 'OK', 'message' => 'not modified' }.to_json if ids.empty?
  
  if jotify.add_tracks_to_playlist(playlist, ids)
    return 200, { 'status' => 'OK', 'message' => "successfully added #{ids.size} tracks" }.to_json
  else
    return 500, { 'status' => 'ERROR', 'message' => 'could not add to playlist' }.to_json
  end  
end



