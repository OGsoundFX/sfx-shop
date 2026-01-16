class SoundDesigner < ApplicationRecord
  after_create_commit :update_user

  belongs_to :user
  has_one :legal_entity, through: :user
  has_many :payouts, through: :legal_entity
  has_many :sfx_packs, dependent: :destroy
  has_many :single_tracks, dependent: :destroy
  has_many :sold_items

  validates :artist_name, presence: true

  has_one_attached :photo, service: Rails.env.production? ? :aws_s3_profile_pics : :cloudinary
  # has_one_attached :photo, service: :aws_s3_profile_pics
  # has_one_attached :photo

  has_one_attached :banner

  def legal_entity
    self.user.legal_entity
  end

  def amount_sold
    conversion_rate = CurrencyRate.last(2).find { |currency| currency.target == self.currency.upcase }.rate
    puts conversion_rate
    self.sold_items.sum do |item|
      if item.currency == self.currency
        item.amount_cents
      else
        item.amount_cents * conversion_rate
      end
    end / 100.0
  end

  def currency
    if self.legal_entity.payment_infos.active.present?
      self.legal_entity.payment_infos.active.last.preferred_currency
    else
      self.legal_entity.payment_infos.last.preferred_currency
    end
  end

  def main_categories
    categories = []
    self.sfx_packs.each do |pack|
      categories << pack.category.split(", ") if pack.category.present?
    end
    categories_count = Hash.new(0)
    categories.flatten.each do |category|
      categories_count[category] += 1
    end
    categories_count.sort_by { |_, count| -count }.first(3).map(&:first)
  end

  def payout_due
  end

  private

  def update_user
    user = self.user
    user.designer = true
    user.save
  end
end
