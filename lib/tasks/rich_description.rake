namespace :rich_description do
  desc "Convert description to rich text"
  task convert: :environment do
    SfxPack.all.each do |pack|
      pack.rich_description.body = pack.description
      pack.save
    end
  end
end
