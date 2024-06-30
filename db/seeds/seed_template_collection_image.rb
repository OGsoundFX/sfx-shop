# ["Jetpack", "Guns & Bullets", "Magic Spells", "Volcano", "Medieval Atmospheres", "Punch in the Face"]

TemplateCollection.all.each do |collection|
  if collection.image.attached?
    collection.image.purge
  end
end

jetpack_file = URI.open("https://res.cloudinary.com/dk9a86uhu/image/upload/v1719757897/sfx_shop/seeds/jetpack.jpg")
collection = TemplateCollection.find_by(title: "Jetpack")
collection.image.attach(io: jetpack_file, filename: "jetpack.jpg", content_type: "image/jpg")

guns_file = URI.open("https://res.cloudinary.com/dk9a86uhu/image/upload/v1719661931/sfx_shop/seeds/guns.jpg")
collection = TemplateCollection.find_by(title: "Guns & Bullets")
collection.image.attach(io: guns_file, filename: "guns.jpg", content_type: "image/jpg")

magic_file = URI.open("https://res.cloudinary.com/dk9a86uhu/image/upload/v1719661930/sfx_shop/seeds/magic.jpg")
collection = TemplateCollection.find_by(title: "Magic Spells")
collection.image.attach(io: magic_file, filename: "magic.jpg", content_type: "image/jpg")

volcano_file = URI.open("https://res.cloudinary.com/dk9a86uhu/image/upload/v1719661931/sfx_shop/seeds/volcano.jpg")
collection = TemplateCollection.find_by(title: "Volcano")
collection.image.attach(io: volcano_file, filename: "volcano.jpg", content_type: "image/jpg")

medieval_file = URI.open("https://res.cloudinary.com/dk9a86uhu/image/upload/v1719653717/sfx_shop/seeds/medieval.jpg")
collection = TemplateCollection.find_by(title: "Medieval Atmospheres")
collection.image.attach(io: medieval_file, filename: "medieval.jpg", content_type: "image/jpg")

punch_file = URI.open("https://res.cloudinary.com/dk9a86uhu/image/upload/v1719653718/sfx_shop/seeds/punch.png")
collection = TemplateCollection.find_by(title: "Punch in the Face")
collection.image.attach(io: punch_file, filename: "punch.png", content_type: "image/png")
