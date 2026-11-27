# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SfxPack, type: :model do
  subject(:sfx_pack) { described_class.new }
  let(:first_sfx_pack) { build(:sfx_pack) }

  context 'validations' do
    it 'validates presence of required attributes' do
      expect(sfx_pack.valid?).to be_falsey
      expect(sfx_pack.errors[:title]).to include("can't be blank")
      expect(sfx_pack.errors[:rich_description]).to include("can't be blank")
      expect(sfx_pack.errors[:size_mb]).to include("can't be blank")
      expect(sfx_pack.errors[:category]).to include("can't be blank")
      expect(sfx_pack.errors[:tags]).to include("can't be blank")
      expect(sfx_pack.errors[:number_of_tracks]).to include("can't be blank")
      expect(sfx_pack.errors[:link]).to include("can't be blank")
      expect(sfx_pack.errors[:product_link]).to include("can't be blank")
      expect(sfx_pack.errors[:sample_rate]).to include("can't be blank")
      expect(sfx_pack.errors[:bit_depth]).to include("can't be blank")
    end

    it 'adds errors when price_cents is negative' do
      sfx_pack.price_cents = -100
      sfx_pack.valid?
      expect(sfx_pack.errors[:price_cents]).to include("can't be negative")
    end

    it 'validates price to be a money object' do
      expect(sfx_pack.price.class).to eq(Money)
    end

    it 'validates rich_description length' do
      expect(sfx_pack.valid?).to be_falsey
      expect(sfx_pack.errors[:rich_description]).to include('is too short (minimum is 20 characters)')
    end

    it 'accepts SoundCloud and YouTube links' do
      ['https://soundcloud.com/artist/track', 'https://www.youtube.com/watch?v=abcdefghijk',
       'https://youtu.be/abcdefghijk'].each do |url|
        pack = described_class.new(link: url)
        pack.valid?

        expect(pack.errors[:link]).to be_empty
      end
    end

    it 'rejects links that are not from SoundCloud or YouTube' do
      pack = described_class.new(link: 'https://example.com/sfx_pack')
      pack.valid?

      expect(pack.errors[:link]).to include('must be a valid SoundCloud or YouTube URL')
    end

    it 'keeps product_link validation independent of the supported link platforms' do
      pack = described_class.new(product_link: 'https://example.com/product')
      pack.valid?

      expect(pack.errors[:product_link]).to be_empty
    end

    it 'includes the invalid announcement value in the validation message' do
      sfx_pack.announcement = 'INVALID'
      sfx_pack.valid?

      expect(sfx_pack.errors[:announcement]).to include(
        "INVALID is not included in the list ['NEW !!!', 'UPGRADE', 'POPULAR']"
      )
    end
  end

  context 'callbacks' do
  end

  describe '#youtube_video_id' do
    {
      'https://www.youtube.com/watch?list=playlist&v=abcdefghijk' => 'abcdefghijk',
      'https://youtu.be/abcdefghijk?si=share-token' => 'abcdefghijk',
      'https://www.youtube.com/embed/abcdefghijk' => 'abcdefghijk',
      'https://www.youtube.com/shorts/abcdefghijk' => 'abcdefghijk',
      'https://www.youtube.com/live/abcdefghijk' => 'abcdefghijk'
    }.each do |url, video_id|
      it "extracts the video ID from #{url}" do
        expect(described_class.new(link: url).youtube_video_id).to eq(video_id)
      end
    end

    it 'returns nil when the link does not contain a video ID' do
      expect(described_class.new(link: 'https://www.youtube.com/playlist?list=abcdefghijk').youtube_video_id).to be_nil
    end
  end
end
