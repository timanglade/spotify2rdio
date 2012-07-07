Gem::Specification.new do |s|
  s.name        = 'spotify2rdio'
  s.version     = '1.0.0'
  s.executables << 'spotify2rdio'
  s.date        = '2012-07-06'
  s.summary     = "Import your Spotify songs into Rdio"
  s.description = "This script will match the tracks you “starred” on Spotify and add them to your Rdio collection."
  s.author      = "Tim Anglade"
  s.email       = 'timanglade@gmail.com'
  s.files       = [ "bin/spotify2rdio",
                    "lib/spotify2rdio.rb",
                    "lib/spotify2rdio/credentials.rb",
                    "lib/spotify2rdio/spotify_appkey.key",
                    "lib/rdio/rdio.rb",
                    "lib/rdio/om.rb" ]
  s.homepage    = 'https://github.com/timanglade/spotify2rdio'
  s.post_install_message = "This utility also requires libspotify. Just `brew install libspotify` on Mac OS X, then run `spotify2rdio to start moving your songs!"
  s.required_ruby_version = '>= 1.9.2'
  s.add_runtime_dependency  "hallon",  ["~> 0.14.0"]
  s.add_runtime_dependency  "nokogiri", ["~> 1.5.2"]
  s.add_runtime_dependency  "rainbow",  ["~> 1.1.3"]
end
