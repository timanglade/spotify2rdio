# spotify2rdio

This script will match the tracks you “starred” on Spotify and add them to your Rdio collection.

The script will match using the [ISRC](http://en.wikipedia.org/wiki/International_Standard_Recording_Code) Spotify provides for the songs. In case there are multiple matches on Rdio, it'll choose the one that has the smallest difference in duration with the original Spotify song.


## Requirements

* A Spotify account and a Rdio account
* A [spotify appkey](https://developer.spotify.com/en/libspotify/application-key/) — this requires that your Spotify account be “Premium” (you can downgrade it once the script has run). Just save the appkey binary file in the same directory as this app.
* [libspotify](http://developer.spotify.com/en/libspotify/overview/). On Mac os, install it with: `brew install libspotify`
* A few rubygems: `gem install hallon nokogiri open-uri rainbow`
* A (free) [Rdio developer account](http://developer.rdio.com/member/register)
* This was tested on 1.9.2-p290 but may work on other versions of ruby.


## How to

1. Fill in lib/spotify2rdio/credentials.template.rb, save as lib/spotify2rdio/credentials.rb
2. Save your [spotify appkey](https://developer.spotify.com/en/libspotify/application-key/) in the same directory
3. `ruby -Ilib ./bin/spotify2rdio`
4. Pass your Spotify login & username when the app requests it
5. Log in to Rdio & authorize the app when the script requests it
6. Enjoy your music on Rdio.


## License & Attribution

om.rb and rdio.rb come from [rdio-simple](https://github.com/rdio/rdio-simple).

The rest of this work is licensed under the WTFPL, version 2.0.


## Comments, Questions

* [@timanglade](https://twitter.com/timanglade)
* timanglade at gmail.com
* pull requests accepted & welcome
