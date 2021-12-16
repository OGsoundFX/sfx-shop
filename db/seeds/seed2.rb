# guns and explosions

puts 'seeding guns and explosions'

require 'json'
filepath = File.join(Rails.root, "db", "seeds", "tracks.json")
serialized_tracks = File.read(filepath)
tracks = JSON.parse(serialized_tracks)['list']
tags = %w(gun explosion action war battle fight epic apocalypse combat strike)

tracks.each do |track|
  link = "https://single-track-list.s3.eu-central-1.amazonaws.com/guns&explosions/#{track['name']}"
  
  # ADD THESE 2 LINES FOR NEXT
  # mp3 = track['name'].split(".wav")[0] + ".mp3"
  # preview_link = "https://single-track-list.s3.eu-central-1.amazonaws.com/monsters/previews/#{mp3}"

  # ALSO ADD BATCH !!!

  title = track['name'].split('.')[0].split('_').join(' ')
  additional_tags_array = title.split(' ')

  additional_tags = additional_tags_array.select do |el|
    /[a-zA-Z]+/.match(el)
  end

  track_tags = tags + additional_tags

  case
  when track['durationSecs'] < 3
    points = 1
    price_cents = 150
  when track['durationSecs'] < 5
    points = 2
    price_cents = 200
  when track['durationSecs'] < 15
    points = 3
    price_cents = 300
  when track['durationSecs'] < 60
    points = 4
    price_cents = 400
  when track['durationSecs'] < 150
    points = 5
    price_cents = 500
  else 
    points = 5
    price_cents = 800
  end

  SingleTrack.create(title: title, link: link, sound_designer_id: 1, category: "action", tags: track_tags, size: track['fileSize'], duration: track['durationSecs'], points: points, sfx_pack_id: 2, price_cents: price_cents, bitrate: track['bitRate'], sample_rate: track['sampleRate'])
  puts "new track created"
end