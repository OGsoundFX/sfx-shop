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
end
