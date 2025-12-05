module DesignerAverageRatingService
  def self.lookup(designer)
    reviews = Review.joins(:sfx_pack).where(sfx_pack: {sound_designer: designer})
    (reviews.sum(&:rating) / reviews.count.to_f).round(2)
  end
end
