SingleTrack.where(category: "monsters").each do |track|
  mp3 = track.link.split('/').last.split(".wav")[0] + ".mp3"
  track.preview_link = "https://single-track-list.s3.eu-central-1.amazonaws.com/monsters/previews/#{mp3}"
  puts track.preview_link
  track.save
end

SingleTrack.where(category: "action").each do |track|
  mp3 = track.link.split('/').last.split(".wav")[0] + ".mp3"
  track.sfx_pack_id = 2
  track.preview_link = "https://single-track-list.s3.eu-central-1.amazonaws.com/guns&explosions/previews/#{mp3}"
  puts track.preview_link
  track.save
end