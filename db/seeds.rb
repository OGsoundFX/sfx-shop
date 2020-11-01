require "open-uri"

puts "destroying DB"

SoundDesigner.destroy_all
Order.destroy_all
Cart.destroy_all
SfxPack.destroy_all

designer = SoundDesigner.create(first_name: 'Olivier', last_name: 'Girardot', address: 'SonnenburegerStrasse 76, 10437 Berlin, Germany', location: 'Berlin', bio: 'nothing special right now')

monster_pack = SfxPack.create(sku: "OGPACK013", title:'Monster Sounds and Atmospheres', description: 'the best sounds ever', category: 'monster, fantasy', tags: 'scary, monster, fantasy, action, adventure', size_mb: 1400, duration: '88mn', number_of_tracks: 1108, price_cents: 2500, sound_designer_id: designer.id, link: "https://www.youtube.com/embed/ymMho53LEVg", list: "https://www.ogsoundfx.com/Documents/Monster_Pack_List_of_Sounds_Unity_2020.pdf", version: 2)
guns_explosions = SfxPack.create(sku: "OGPACK002", title:'Guns and Explosions', description: 'the best sounds ever', category: 'weapons, war', tags: 'war, realistic, battle, guns, explosions', size_mb: 500, duration: '29mn', number_of_tracks: 418, price_cents: 1900, sound_designer_id: designer.id, link: "https://soundcloud.com/ogsoundfx/guns-explosions-preview-track-2", list: "https://www.ogsoundfx.com/Documents/Guns_&_Explosions_List_of_Sounds.pdf", version: 1)
outdoor_atmospheres = SfxPack.create(sku: "OGPACK014", title:'Outdoor Atmospheres', description: 'the best sounds ever', category: 'atmospheres', tags: 'nature, realistic, outdoor', size_mb: 5840, duration: '6 hours', number_of_tracks: 96, price_cents: 1900, sound_designer_id: designer.id, link:"https://youtu.be/75DSTMFMejg", list: "https://www.ogsoundfx.com/Documents/Outdoor_Atmospheres_List_of_Sounds.pdf", version: 1)
underground_atmospheres = SfxPack.create(sku: "OGPACK004", title:'Underground Atmospheres', description: 'the best sounds ever', category: 'Atmospheres', tags: 'fantasy, underground, nature, cavern, atmospheres', size_mb: 1400, duration: '90mn', number_of_tracks: 32, price_cents: 1500, sound_designer_id: designer.id, link: "https://youtu.be/YhQ_E7aznQ8", list: "https://www.ogsoundfx.com/Documents/Underground_Atmospheres_List_of_SFX.pdf", version: 1)
natural_disasters = SfxPack.create(sku: "OGPACK009", title:'Natural Disasters', description: 'the best sounds ever', category: 'Natural Occurences', tags: 'nature, atmospheres, disaster, catastrophe, volcano, eruption, explosion, earthquake, landslide, avalanche', size_mb: 840, duration: '50mn', number_of_tracks: 53, price_cents: 1500, sound_designer_id: designer.id, link: "https://youtu.be/3-vACKDRc3A", list: "https://www.ogsoundfx.com/Documents/Natural_Disasters_List_of_SFX.pdf", version: 1)

monster_pack.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604053462/sfx_shop/MonsterPack_Transp_small_jhfded.png'), filename: 'image', content_type: "image/jpg")
guns_explosions.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604052938/sfx_shop/Guns_Explosions_transp_small_rywioe.png'), filename: 'image', content_type: "image/jpg")
outdoor_atmospheres.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604054507/sfx_shop/UndergroundAtmopsheres_transp_small_kpso85.png'), filename: 'image', content_type: "image/jpg")
underground_atmospheres.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604053462/sfx_shop/MonsterPack_Transp_small_jhfded.png'), filename: 'image', content_type: "image/jpg")
natural_disasters.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1604054506/sfx_shop/NaturalDisasters_transp_small_uokbyk.png'), filename: 'image', content_type: "image/jpg")

puts "created #{SoundDesigner.count} sound designers"
puts "created #{SfxPack.count} sound effect packs"
