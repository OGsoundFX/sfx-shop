FactoryBot.define do
  factory :sound_designer do
    association :user
    artist_name { "Sample Artist" }
    bio { "This is a sample bio with sufficient length to pass validation." }

    after(:create) do |sd|
      # Attach a small fixture image to satisfy ActiveStorage attachment validation
      sd.photo.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample.jpg')), filename: 'sample.jpg', content_type: 'image/jpeg')
      sd.save!
    end
  end
end
