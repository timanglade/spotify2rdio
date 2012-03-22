require 'rubygems'
require 'hallon'
require 'nokogiri'
require 'open-uri'
require 'rainbow'
require './rdio'
require './credentials'

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

ENV['HALLON_APPKEY'] = File.expand_path('./spotify_appkey.key')

session = Hallon::Session.initialize IO.read(ENV['HALLON_APPKEY']) do
  on(:connection_error) do |error|
    Hallon::Error.maybe_raise(error)
  end

  on(:logged_out) do
    abort "[FAIL] Logged out!"
  end
end

session.login!(ENV['HALLON_USERNAME'], ENV['HALLON_PASSWORD'])

rdio = Rdio.new([RDIO_CONSUMER_KEY, RDIO_CONSUMER_SECRET])

username = ENV['HALLON_USERNAME']
playlist = Hallon::User.new(username).starred

keys = []

puts "\nFirst I'll look for matches of your starred items..."
puts "Green = perfect match found on rdio".color(:green)
puts "Yellow = found a match with a slightly different duration. (Will still be added to your rdio collection)".color(:yellow)
puts "Red = no streamable match found on rdio\n".color(:red)

session.wait_for { playlist.loaded? }
starred_size = playlist.size

playlist.tracks.each do |s_track|
  session.wait_for { s_track.loaded? }
  next if s_track.local?
  lookup_tries = 0
  isrc = lookup_isrc(s_track, 5)
  r_tracks = get_rdio_tracks(rdio, isrc, 5)
  if r_tracks.size > 0
    closest = nil
    r_tracks.each do |r_track|
      next if r_track.nil?
      next unless r_track['canStream'] && r_track['key']
      if closest.nil?
        closest = r_track
      else
        closest = r_track if (closest['duration'] - s_track.duration) > (r_track['duration'] - s_track.duration)
      end
    end
    if closest.nil?
      puts "#{s_track.name}".color(:red)
    else
      keys << closest['key']
      if closest['duration'].to_i != s_track.duration.to_i
        puts "#{s_track.name}".color(:yellow)
      else
        puts "#{s_track.name}".color(:green)
      end
    end
  else
    puts "#{s_track.name}".color(:red)
  end
end

keys = keys.uniq

puts "\nFound matches for #{keys.size} out of #{starred_size} songs."

# authenticate against the Rdio service
url = rdio.begin_authentication('oob')
system("open", url)
puts "Please enter the code you received at "+url
verifier = gets.chomp
rdio.complete_authentication(verifier)

rdio.call('addToCollection', {'keys' => keys.join(',')})

puts "Added the matches to your rdio collection!\n\n"

