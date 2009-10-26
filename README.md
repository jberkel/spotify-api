
# Spotify-API

I got tired of waiting for Spotify to release their API (if they release it), so decided to roll my own based on the awesome
work done by [#hack.se](http://despotify.se) (despotify) and Felix Bruns who created a Java port of despotify called 
[jotify](http://jotify.felixbruns.de/). Add JRuby, Sinatra and some glue to the mix and you (almost) have an API.

*Important*: in order to use this API you'll need a premium spotify account! This API is as unofficial as it gets and *NOT* supported
by Spotify in any way.

At the moment the following features are implemented:

* searching 							[GET /(albums|tracks|artists)?name=Foo]
* list user's playlists 	[GET /playlists]
* get shared playlist			[GET /playlist/id]
* create new playlist   	[POST /playlists]
* update playlists        [PUT	/playlists/id]
	
## Installation

Prerequisites: *Java 6+*, JRuby 1.3.x.

    $ jruby -S gem install spotify-api --source http://gemcutter.org
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
            "size": 1,
            "collaborative": false
          }
        ]
      },
      "status": "OK"
    }
    
## Examples

See examples directory for usage. The demo application ([lastfm2spotify_loved_tracks](/jberkel/spotify-api/blob/master/examples/lastfm2spotify_loved_tracks)) will
grab all recently loved tracks by your last.fm friends to create a new
spotify playlist. A nice way to listen to some good new music (if you share a similar music taste with most of your friends :)).                      

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
