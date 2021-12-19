# Outdoor Atmospheres seed
puts "destroying previous batch #2 entries" # replace batch number

SingleTrack.where(batch: 2).destroy_all # replace batch number

puts 'seeding outdoor atmospheres batch #2' # replace batch number

require 'json'
filepath = File.join(Rails.root, "db", "seeds", "tracks.json") # replace "tracks.json" with the JSON file name
serialized_tracks = File.read(filepath)
tracks = JSON.parse(serialized_tracks)['list']
tags = %w(outdoor atmosphere nature wild wilderness scenery background dungeon game board) + %w(beach summer sand seagull ocean wave) # replace tags

tracks.each do |track| # change the destination folder
  link = "https://single-track-list.s3.eu-central-1.amazonaws.com/outdooratmospheres/#{track['name']}"
  
  # create preview link
  mp3 = track['name'].split(".wav")[0] + ".mp3" # change the destination folder
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
  when track['durationSecs'] < 8
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
  SingleTrack.create(title: title, link: link, sound_designer_id: 1, category: "outdoor", tags: track_tags, size: track['fileSize'], duration: track['durationSecs'], points: points, sfx_pack_id: 3, price_cents: price_cents, bitrate: track['bitRate'], sample_rate: track['sampleRate'], batch: 2, preview_link: preview_link)
  puts "new track created"
end