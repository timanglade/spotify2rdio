require 'hallon'
require 'nokogiri'
require 'rainbow'
require 'highline/import'

require 'open-uri'

require 'rdio/rdio'
require 'spotify2rdio/credentials'

def lookup_isrc(track, tries)
  Nokogiri::XML(open("http://ws.spotify.com/lookup/1/?uri=#{track.to_link.to_str}")).css("id").text
rescue
  tries -= 1
  sleep 1
  retry if tries > 0
  raise
end

def get_rdio_tracks(rdio, isrc, tries)
  rdio.call('getTracksByISRC', {'isrc' => isrc })['result']
rescue
  tries -= 1
  sleep 1
  retry if tries > 0
  raise
end
