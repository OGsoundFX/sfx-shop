require "open-uri"

SfxPack.all.each do |pack|
  pack.photos.purge
end

weather_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216778/sfx_shop/new_covers/Front_Final_edfktw.jpg").open
underground_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216765/sfx_shop/new_covers/Front_Final_xr6tvc.jpg").open
outdoor_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216744/sfx_shop/new_covers/Front_Final_kmi6ee.jpg").open
natural_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216735/sfx_shop/new_covers/Front_Final_orvfsg.jpg").open
monster_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216723/sfx_shop/new_covers/Front_Final_mtmlfu.jpg").open
guns_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216705/sfx_shop/new_covers/Front_Final_rut43o.jpg").open
ghost_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216695/sfx_shop/new_covers/Front_Final_m5bdhn.jpg").open
free_url = URI.parse("https://res.cloudinary.com/dk9a86uhu/image/upload/v1749216687/sfx_shop/new_covers/Front_Final_bz8p3d.jpg").open

weather = SfxPack.find_by("title ilike ?", "%weather%")
underground = SfxPack.find_by("title ilike ?", "%underground%")
outdoor = SfxPack.find_by("title ilike ?", "%outdoor%")
natural = SfxPack.find_by("title ilike ?", "%natural%")
monster = SfxPack.find_by("title ilike ?", "%monster%")
guns = SfxPack.find_by("title ilike ?", "%guns%")
ghost = SfxPack.find_by("title ilike ?", "%ghost%")
free = SfxPack.find_by("title ilike ?", "%free%")

weather.photos.attach(io: weather_url, filename: "weather.png", content_type: "image/png" )
underground.photos.attach(io: underground_url, filename: "underground.png", content_type: "image/png" )
outdoor.photos.attach(io: outdoor_url, filename: "outdoor.png", content_type: "image/png" )
natural.photos.attach(io: natural_url, filename: "natural.png", content_type: "image/png" )
monster.photos.attach(io: monster_url, filename: "monster.png", content_type: "image/png" )
guns.photos.attach(io: guns_url, filename: "guns.png", content_type: "image/png" )
ghost.photos.attach(io: ghost_url, filename: "ghost.png", content_type: "image/png" )
free.photos.attach(io: free_url, filename: "free.png", content_type: "image/png" )
