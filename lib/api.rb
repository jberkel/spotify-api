require 'json'
require 'sinatra/base'

Sinatra::Application.get('/q') do
  content_type :json
  artist, track = params[:artist], params[:track]
  res = jotify.search("#{artist ? 'artist:' + artist : ''} #{track ? 'track:' + track : ''}")
  {
    'status'=>'OK', 
    'result'=> res.tracks.map do |t| 
      { :id=>t.getId(), :title=>t.title, :artist=>t.artist.name, :album=>t.album.name, :url=>t.link } 
    end
  }.to_json
end


