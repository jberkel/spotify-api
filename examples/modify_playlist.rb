#!/usr/bin/env ruby

require 'rubygems'
require 'rest_client'
require 'json'
require 'pp'

#spotify:user:jberkel:playlist:51QyZ8kHWdx1wuetLfs571
#spotify:user:jberkel:playlist:52vlrAr9RdphpgVtP2SAGP (empty)
#spotify:user:jberkel:playlist:5aZg2QhSogW4Ukw7Q6kjRO
#spotify:user:jberkel:playlist:1G1BCuefz7bvZdQ5QbGLPR
#spotify:user:jberkel:playlist:28C9HrzCMmlSReG4mSQeuQ
#spotify:user:jberkel:playlist:4h9wgIOBjlqMoMD0C7LdDs
p_id  = '4h9wgIOBjlqMoMD0C7LdDs'
p_url = "http://localhost:3000/playlists/#{p_id}"
puts "getting playlist #{p_id}"
resp = RestClient.get p_url
playlist = JSON.parse(resp)
pp playlist


existing_songs = playlist['result']['tracks'].map { |t| t['id'] }


add_songs = ['1VaucR6Bsks5Q9bYBsXvuF', 'spotify:track:3RIgfgKZm7khbOokcYeFn0']
#add_songs = ['spotify:track:2jpVApJaYkYGYRL7WQHnvu']
#add_songs = [ 'spotify:track:4hXA0NkPLFf6mXMxzsQicd' ]
RestClient.put p_url, {
  'name' => 'a new name',
  'collaborative' => false,
  'tracks' => (existing_songs + add_songs).map { |s| { 'id'=>s } }
}.to_json
