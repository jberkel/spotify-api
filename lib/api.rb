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
      { :id=>t.getId(), :title=>t.title, :artist=>t.artist.name, :album=>t.album.name, :url=>t.link, :popularity=>a.popularity } 
    end
  }.to_json
end

Sinatra::Application.get('/albums') do
  content_type :json
  raise ArgumentError, "need name" unless params[:name]
    
  res = jotify.search([query(:album, :name), query(:artist)].join(' ') )
  {
    'status'=>'OK', 
    'result'=> res.albums.map do |a| 
      { :id=>a.getId(), :name=>a.name, :artist=>a.artist.name, :year=>a.year, :type=>a.type, :url=>a.link, :popularity=>a.popularity } 
    end
  }.to_json
end

Sinatra::Application.get('/artists') do
  content_type :json
  raise ArgumentError, "need name" unless params[:name]
    
  res = jotify.search(query(:artist, :name))
  {
    'status'=>'OK', 
    'result'=> res.artists.map do |a| 
      { :id=>a.getId(), :name=>a.name, :url=>a.link, :popularity=>a.popularity } 
    end
  }.to_json
end


