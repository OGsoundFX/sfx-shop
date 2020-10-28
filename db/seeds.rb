# require "open-uri"

# puts "destroying DB"

# SoundDesigner.destroy_all
# Order.destroy_all
# Cart.destroy_all
# SfxPack.destroy_all

# designer = SoundDesigner.create(first_name: 'Olivier', last_name: 'Girardot', email: 'olive_girardot@hotmail.com', password: '123456', address: 'SonnenburegerStrasse 76, 10437 Berlin, Germany', location: 'Berlin')

# monster_pack = SfxPack.create(sku: "OGPACK013", title:'Monster Pack', description: 'the best sounds ever', category: 'monster', tags: 'scary, monster, fantasy', size_mb: 1076, duration: '90mn', number_of_tracks: 1018, price_cents: 2000, sound_designer_id: designer.id)
# guns_explosions = SfxPack.create(sku: "OGPACK002", title:'Guns and Explosions', description: 'the best sounds ever', category: 'weapons', tags: 'war, realistic, battle', size_mb: 570, duration: '80mn', number_of_tracks: 250, price_cents: 1550, sound_designer_id: designer.id)
# test_pack = SfxPack.create(sku: "OGFS001", title:'Test Pack', description: 'the best sounds ever', category: 'test', tags: 'test, free', size_mb: 570, duration: '80mn', number_of_tracks: 250, price_cents: 100, sound_designer_id: designer.id)
# test_pack2 = SfxPack.create(sku: "OGFS001", title:'Test Pack', description: 'the best sounds ever', category: 'test', tags: 'test, free', size_mb: 570, duration: '80mn', number_of_tracks: 250, price_cents: 300, sound_designer_id: designer.id)

# monster_pack.photos.attach(io: URI.open('https://www.ogsoundfx.com/NeWsfXsHoP/Monsters-pack_New-2020.jpg'), filename: 'image')
# guns_explosions.photos.attach(io: URI.open('https://www.ogsoundfx.com/NeWsfXsHoP/Guns-Explosions-Cover_New-1.jpg'), filename: 'image')
# guns_explosions.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1603104054/sfx_shop/monster_zzsdcm.jpg'), filename: 'image')
# test_pack.photos.attach(io: File.open(Rails.root.join("app", "assets", "images", "monster.jpg")), filename: 'image.jpg')
# test_pack2.photos.attach(io: File.open(Rails.root.join("app", "assets", "images", "monster.jpg")), filename: 'image.jpg')

# monster_pack.photos.attach(io: File.open(Rails.root.join("app", "assets", "images", "test.jpg")), filename: 'image.jpg')

# puts "created #{SoundDesigner.count} sound designers"
# puts "created #{SfxPack.count} sound effect packs"

# monster_pack = SfxPack.where(title: "Monster Pack")[0]
# monster_pack.photos.attach(io: URI.open('https://www.ogsoundfx.com/NeWsfXsHoP/Monsters-pack_New-2020.jpg'), filename: 'image')
# monster_pack.photos.attach(io: URI.open('https://res.cloudinary.com/dk9a86uhu/image/upload/v1603886106/sumqq9z2xodfcebgx160x7pll08u.jpg'), filename: 'image', content_type: "image/jpg")
# monster_pack.photos.attach(io: File.open(Rails.root.join("app", "assets", "images", "monster.jpg")), filename: 'image.jpg')

monster_pack = SfxPack.where(title: "Monster Pack")[0]
monster_pack.link = "https://youtu.be/ymMho53LEVg"
monster_pack.save
