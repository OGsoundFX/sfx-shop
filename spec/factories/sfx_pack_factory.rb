# This will guess the SfxPack class
FactoryBot.define do
  factory :sfx_pack do
    title { "Sample Sfx Pack" }
    description { "A sample sound effects pack with enough length to pass validations" }
    size_mb { 100 }
    category { "fantasy" }
    tags { "fantasy, adventure" }
    number_of_tracks { 10 }
    price_cents { 999 }
    currency { "usd" }
    link { "https://example.com/sfx_pack" }
    product_link { "https://example.com/product" }
    sample_rate { 44100 }
    bit_depth { 16 }
    accept_conditions { true }

    association :sound_designer

    after(:build) do |pack|
      pack.photos.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample.jpg')), filename: 'sample.jpg', content_type: 'image/jpeg')
    end
  end
end
