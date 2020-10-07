# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "destroying DB"

SoundDesigner.destroy_all
SfxPack.destroy_all

designer = SoundDesigner.create(first_name: 'Olivier', last_name: 'Girardot', email: 'olive_girardot@hotmail.com', password: '123456', address: 'SonnenburegerStrasse 76, 10437 Berlin, Germany', location: 'Berlin')

SfxPack.create(title:'Monster Pack', description: 'the best sounds ever', category: 'monster', tags: 'scary, monster, fantasy', size_mb: 1076, duration: '90mn', number_of_tracks: 1018, price: 20.00, sound_designer_id: designer.id)
SfxPack.create(title:'Magic Spells Pack', description: 'the best sounds ever', category: 'spells', tags: 'scary, magic, fantasy', size_mb: 1076, duration: '80mn', number_of_tracks: 250, price: 15.00, sound_designer_id: designer.id)


puts "created #{SoundDesigner.count} sound designers"
puts "created #{SfxPack.count} sound effect packs"
