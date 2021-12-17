# Outdoor Atmospheres seed
puts "destroying previous batch #3 entries" # replace batch number

SingleTrack.where(batch: 3).destroy_all # replace batch number

puts 'seeding outdoor atmospheres batch #3' # replace batch number

require 'json'
filepath = File.join(Rails.root, "db", "seeds", "tracks3.json") # replace "tracks3.json"
serialized_tracks = File.read(filepath)
tracks = JSON.parse(serialized_tracks)['list']
tags = %w(outdoor atmosphere nature wild wilderness scenery background dungeon game board) + %w(creepy crow ghost spirit scary haunted dead zombie) # replace tags

tracks.each do |track|
  link = "https://single-track-list.s3.eu-central-1.amazonaws.com/outdooratmospheres/#{track['name']}"
  
  # create preview link
  mp3 = track['name'].split(".wav")[0] + ".mp3"
  preview_link = "https://single-track-list.s3.eu-central-1.amazonaws.com/outdooratmospheres/previews/#{mp3}"

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

  # replace sound_designer_id, category, sfx_pack_id, batch
  SingleTrack.create(title: title, link: link, sound_designer_id: 1, category: "outdoor", tags: track_tags, size: track['fileSize'], duration: track['durationSecs'], points: points, sfx_pack_id: 3, price_cents: price_cents, bitrate: track['bitRate'], sample_rate: track['sampleRate'], batch: 3, preview_link: preview_link)
  puts "new track created"
end