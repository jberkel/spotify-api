#!/usr/bin/env ruby

require 'rubygems'
require 'rest_client'
require 'json'
require 'pp'

puts "creating a new playlist"
resp = RestClient.post 'http://localhost:3000/playlists', :name=>'my shiny playlist'
if resp.code == 201
  location = resp.headers[:location]
  puts "201 created (#{location})"
  spotify_id = location[location.rindex('/')+1..-1] 
  
  puts "adding some tracks to it"
  resp = RestClient.put "http://localhost:3000/playlists/#{spotify_id}", { 
    "tracks" => [ {'id'=>'6qHiOf1BFCQIzAjJsRbMfY'}, {'id'=>'1VaucR6Bsks5Q9bYBsXvuF'} ] 
  }.to_json
  puts resp
else
  raise resp.to_s
end
  
  