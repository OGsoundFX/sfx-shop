namespace :generate_summary do
  desc "For packs that have a description but no summary, generate a summary from the description"
  task generate: :environment do
    SfxPack.where("description IS NOT NULL AND summary IS NULL").each do |pack|
      pack.generate_summary_task
      pack.save
    end
  end
end
