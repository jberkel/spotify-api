#!/usr/bin/env ruby

require 'rubygems'
require 'rest_client'
require 'json'
require 'pp'

puts "creating a new playlist"
resp = RestClient.post('http://localhost:3000/playlists', {
  "name"=>'my shiny playlist',
  "tracks" => [ {'id'=>'6qHiOf1BFCQIzAjJsRbMfY'}, {'id'=>'1VaucR6Bsks5Q9bYBsXvuF'} ] 
}.to_json)

if resp.code == 201
  location = resp.headers[:location]
  puts "201 created (#{location})"
else
  raise resp.to_s
end
  
  