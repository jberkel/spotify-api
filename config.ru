require './lib/jotify/api'
Sinatra::Application.set :environment, :production
run Sinatra::Application
