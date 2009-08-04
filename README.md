
# Spotify-API

I was tired of waiting for Spotify to release their API (if they release it), so decided to roll my own based on the awesome
reverse engineering work done by [despotify.se](http://despotify.se) and [Felix Bruns](http://www.felixbruns.de/) who created
a Java version of despotify called [jotify](http://jotify.felixbruns.de/). Add JRuby, Sinatra and some glue to the mix and you 
(almost) have an API.

*Important*: in order to use this API you'll need a premium spotify account! This API is as unofficial as it gets and *NOT* supported
by Spotify in any way.

## Installation

		$ jruby -S gem install jberkel-spotify-api --source http://gems.github.com
		$ jruby -S spotify-api-server --account login:password
		== Sinatra/0.9.4 has taken the stage on 3000 for development with backup from WEBrick
		[2009-08-04 01:21:03] INFO  WEBrick 1.3.1
		[2009-08-04 01:21:03] INFO  ruby 1.8.6 (2009-07-24) [java]
		[2009-08-04 01:21:03] INFO  WEBrick::HTTPServer#start: pid=12162 port=3000
	
		$ curl http://localhost:3000/playlists | jsonpretty
		{
		  "result": {
		    "playlists": [
		      {
		        "name": "my shiny playlist",
		        "author": "jberkel",
		        "url": "http:\/\/open.spotify.com\/user\/jberkel\/playlist\/5EXLGE7HPVPjvlxPmIfrDe",
		        "revision": 2,
		        "id": "b9fe3dcf88945d146ef18117faa61ab4",
		        "tracks": [
		          {
		            "artist": "Elmore Judd",
		            "title": "Disco In 4 Pieces",
		            "url": "http:\/\/open.spotify.com\/track\/1VaucR6Bsks5Q9bYBsXvuF",
		            "id": "3f2752a98dd947c5855278a88159d7b1",
		            "album": "Insect Funk",
		            "popularity": 0.325379997491837
		          },
		          {
		            "artist": "40winks",
		            "title": "Goodmorning (intro)",
		            "url": "http:\/\/open.spotify.com\/track\/6qHiOf1BFCQIzAjJsRbMfY",
		            "id": "d34a3a6daeed4f93983068e4e8c26cd6",
		            "album": "Sound Puzzle",
		            "popularity": 0.170609995722771
		          }
		        ],
		        "collaborative": false
		      }
		    ]
		  },
		  "status": "OK"
		}
		
See examples directory / more documentation.
	
## Credits

Contains code from the jotify project:

Copyright (c) 2009, Felix Bruns <felixbruns@web.de>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
