require "open-uri"

puts "destroying DB"

Order.destroy_all
Cart.destroy_all
SfxPack.destroy_all
SoundDesigner.destroy_all

designer = SoundDesigner.create(first_name: 'Olivier', last_name: 'Girardot', address: 'SonnenburegerStrasse 76, 10437 Berlin, Germany', location: 'Berlin', bio: 'nothing special right now')


puts "created #{SoundDesigner.count} sound designers"
puts "created #{SfxPack.count} sound effect packs"

# re attributing pics

# monster = SfxPack.where(title: "Monster SFX Pack")[0]
# guns = SfxPack.where(title: "Guns and Explosions")[0]
# outdoor = SfxPack.where(title: "Outdoor Atmospheres")[0]
# underground = SfxPack.where(title: "Underground Atmospheres")[0]
# natural = SfxPack.where(title: "Natural Disasters")[0]

# monster.photos.destroy_all
# guns.photos.destroy_all
# outdoor.photos.destroy_all
# underground.photos.destroy_all
# natural.photos.destroy_all

# monster.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604325686/sfx_shop/MonsterPack_Transp_small_crop_d1d14s.png'), filename: 'image', content_type: "image/jpg")
# guns.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604325686/sfx_shop/Guns_Explosions_transp_small_crop_mrc3yy.png'), filename: 'image', content_type: "image/jpg")
# outdoor.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604325686/sfx_shop/OutdoorAtmospheres_transp_small_crop_iubxlm.png'), filename: 'image', content_type: "image/jpg")
# underground.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604325688/sfx_shop/UndergroundAtmopsheres_transp_small_crop_izhqkj.png'), filename: 'image', content_type: "image/jpg")
# natural.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604325685/sfx_shop/NaturalDisasters_transp_small_crop_d5gfic.png'), filename: 'image', content_type: "image/jpg")
