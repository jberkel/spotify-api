#!/usr/bin/env ruby

require 'rubygems'
require 'rest_client'
require 'json'
require 'pp'

puts "getting all playlists"
resp = RestClient.get 'http://localhost:3000/playlists'
playlists = JSON.parse(resp)
pp playlists

playlists['result']['playlists'].each do |p|
  puts "retrieving details for playlist #{p['name']}:"
  pp JSON.parse(RestClient.get "http://localhost:3000/playlists/#{p['id']}")
end
