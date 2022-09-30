# Outdoor Atmospheres seed

# replace batch number if necessary
# puts "destroying previous batch #2 entries"

# replace batch number if necessary
# SingleTrack.where(batch: 2).destroy_all

puts 'seeding magic spells batch #49' # replace batch number

require 'json'
filepath = File.join(Rails.root, "db", "seeds", "tracks.json") # replace "tracks.json" with the JSON file name
serialized_tracks = File.read(filepath)
tracks = JSON.parse(serialized_tracks)['list']
tags = %w(fantasy magic haunted spirits hypnotic terror strange chilling eerie spooky horrifying horrific ghost manifestation demon appearance shadow soul spectre spell cast wizardry illusion freeze paralyse) # replace tags

tracks.each do |track| # change the destination folder
  link = "https://single-track-list.s3.eu-central-1.amazonaws.com/magic/#{track['name']}"
  
  # create preview link
  mp3 = track['name'].split(".wav")[0] + ".mp3" # change the destination folder
  preview_link = "https://single-track-list.s3.eu-central-1.amazonaws.com/magic/previews/#{mp3}"

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
  when track['durationSecs'] < 300
    points = 5
    price_cents = 500
  else 
    points = 5
    price_cents = 700
  end

  # replace sound_designer_id, category, sfx_pack_id, batch
  SingleTrack.create(title: title, link: link, sound_designer_id: 1, category: "magic", tags: track_tags, size: track['fileSize'], duration: track['durationSecs'], points: points, sfx_pack_id: nil, price_cents: price_cents, bitrate: track['bitRate'], sample_rate: track['sampleRate'], batch: 49, preview_link: preview_link)
  puts "new track created"
end