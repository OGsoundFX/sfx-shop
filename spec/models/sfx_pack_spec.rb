# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SfxPack, type: :model do
  subject(:sfx_pack) { described_class.new }
  let(:first_sfx_pack) { build(:sfx_pack) }

  context 'validations' do
    it 'validates presence of required attributes' do
      expect(sfx_pack.valid?).to be_falsey
      expect(sfx_pack.errors[:title]).to include("can't be blank")
      expect(sfx_pack.errors[:description]).to include("can't be blank")
      expect(sfx_pack.errors[:size_mb]).to include("can't be blank")
      expect(sfx_pack.errors[:category]).to include("can't be blank")
      expect(sfx_pack.errors[:tags]).to include("can't be blank")
      expect(sfx_pack.errors[:number_of_tracks]).to include("can't be blank")
      expect(sfx_pack.errors[:price_cents]).to include("can't be blank")
      expect(sfx_pack.errors[:link]).to include("can't be blank")
      expect(sfx_pack.errors[:product_link]).to include("can't be blank")
      expect(sfx_pack.errors[:sample_rate]).to include("can't be blank")
      expect(sfx_pack.errors[:bit_depth]).to include("can't be blank")
    end

    it 'validates price to be a money object' do
      expect(sfx_pack.price.class).to eq(Money)
    end

    it 'validates description length' do
      expect(sfx_pack.valid?).to be_falsey
      expect(sfx_pack.errors[:description]).to include('is too short (minimum is 20 characters)')
    end
  end

  context 'callbacks' do
  end
end
