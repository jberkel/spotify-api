#!/usr/bin/env ruby

require 'rubygems'
require 'rest_client'
require 'json'
require 'pp'

puts "searching for album: Moon Safari"
pp JSON.parse(RestClient.get('http://localhost:3000/albums?name=Moon+Safari'))

puts "searching for track: The End"
pp JSON.parse(RestClient.get('http://localhost:3000/tracks?name=The+End'))

puts "searching for artist: The Doors"
pp JSON.parse(RestClient.get('http://localhost:3000/artists?name=The+Doors'))

